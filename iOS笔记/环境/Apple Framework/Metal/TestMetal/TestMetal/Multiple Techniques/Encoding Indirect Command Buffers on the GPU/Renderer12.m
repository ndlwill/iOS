//
//  Renderer12.m
//  TestMetal
//
//  Created by youdun on 2023/9/25.
//

#import "Renderer12.h"
#import "ShaderTypes12.h"

#define MOVE_GRID 1

// The max number of frames in flight
static const NSUInteger kMaxFramesInFlight = 3;

typedef enum MovementDirection {
    MovementDirectionRight,
    MovementDirectionUp,
    MovementDirectionLeft,
    MovementDirectionDown,
} MovementDirection;

typedef struct ObjectMesh {
    Vertex12 *vertices;
    uint32_t numVerts;
} ObjectMesh;

@implementation Renderer12
{
    dispatch_semaphore_t _inFlightSemaphore;

    id<MTLDevice> _device;

    id<MTLCommandQueue> _commandQueue;
    
    // Array of Metal buffers storing vertex data for each rendered object. If using a single combined buffer to store all mesh this will be an array of size 1
    id<MTLBuffer> _vertexBuffer;

    // The Metal buffer storing per object parameters for each rendered object
    id<MTLBuffer> _objectParameters;

    // The Metal buffers storing per frame uniform data
    id<MTLBuffer> _frameStateBuffer[kMaxFramesInFlight];
    
    // Render pipeline executinng indirect command buffer
    id<MTLRenderPipelineState> _renderPipelineState;

    // Compute pipeline used to build indirect command buffer when we do culling on GPU
    id<MTLComputePipelineState> _computePipelineState;
    
    // Argument buffer containing the indirect command buffer encoded in the kernel
    id<MTLBuffer> _icbArgumentBuffer;
    
    // Index into per frame uniforms to use for the current frame
    NSUInteger _inFlightIndex;

    // Number of frames rendered
    NSUInteger _frameNumber;
    
    // The indirect command buffer encoded and executed
    id<MTLIndirectCommandBuffer> _indirectCommandBuffer;
    
    // Variables affecting position of objects in scene
    vector_float2         _gridCenter;
    float                 _movementSpeed;
    MovementDirection     _objectDirection;
    
    vector_float2 _aspectScale;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
    self = [super init];
    if (self) {
        mtkView.clearColor = MTLClearColorMake(0.0, 0.0, 0.5, 1.0f);
        _device = mtkView.device;
        
        // Initialize ivars affecting object position
        _gridCenter      = (vector_float2){ 0.0, 0.0 };
        _movementSpeed   = 0.15;
        _objectDirection = MovementDirectionUp;

        _inFlightSemaphore = dispatch_semaphore_create(kMaxFramesInFlight);
        
        // Create the command queue
        _commandQueue = [_device newCommandQueue];
        
        // Load the shaders from default library
        id <MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        id <MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader12"];
        id <MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader12"];
        
        mtkView.depthStencilPixelFormat = MTLPixelFormatDepth32Float;
        mtkView.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
        mtkView.sampleCount = 1;
        
        // Create a reusable pipeline state
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"Render Pipeline";
        pipelineStateDescriptor.sampleCount = mtkView.sampleCount;
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        pipelineStateDescriptor.depthAttachmentPixelFormat = mtkView.depthStencilPixelFormat;
        // Needed for this pipeline state to be used in indirect command buffers.
        pipelineStateDescriptor.supportIndirectCommandBuffers = YES;
        
        NSError *error;
        // MARK: - MTLRenderPipelineState
        _renderPipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        NSAssert(_renderPipelineState, @"Failed to create pipeline state: %@", error);
        
        // MARK: - id<MTLComputePipelineState>
        id<MTLFunction> GPUCommandEncodingKernel = [defaultLibrary newFunctionWithName:@"cullMeshesAndEncodeCommands"];
        _computePipelineState = [_device newComputePipelineStateWithFunction:GPUCommandEncodingKernel
                                                                       error:&error];
        NSAssert(_computePipelineState ,@"Failed to create compute pipeline state: %@", error);
        
        // Generate gear mesh data in malloced memory to later copy into a single Metal buffer
        ObjectMesh *tempMeshes;
        {
            tempMeshes = malloc(sizeof(ObjectMesh) * NumObjects12);

            for (int objectIdx = 0; objectIdx < NumObjects12; objectIdx++)
            {
                // Choose the parameters to generate a mesh so that each one is unique.
                uint32_t numTeeth = random() % 50 + 3;
                float innerRatio = 0.2 + (random() / (1.0 * RAND_MAX)) * 0.7;
                float toothWidth = 0.1 + (random() / (1.0 * RAND_MAX)) * 0.4;
                float toothSlope = (random() / (1.0 * RAND_MAX)) * 0.2;

                // Create a vertex buffer and initialize it with a unique 2D gear mesh.
                tempMeshes[objectIdx] = [self newGearMeshWithNumTeeth:numTeeth
                                                           innerRatio:innerRatio
                                                           toothWidth:toothWidth
                                                           toothSlope:toothSlope];
            }
        }
        
        // Create and fill array containing parameters for each object
        {
            NSUInteger objectParameterArraySize = NumObjects12 * sizeof(ObjectParameters12);

            _objectParameters = [_device newBufferWithLength:objectParameterArraySize options:0];

            _objectParameters.label = @"Object Parameters Array";
        }
        
        // Create a single buffer with vertices for all gears
        {
            size_t bufferSize = 0;

            for (int objectIdx = 0; objectIdx < NumObjects12; objectIdx++)
            {
                size_t meshSize = sizeof(Vertex12) * tempMeshes[objectIdx].numVerts;
                bufferSize += meshSize;
            }

            _vertexBuffer = [_device newBufferWithLength:bufferSize options:0];

            _vertexBuffer.label = @"Combined Vertex Buffer";
        }
        
        // Copy each mesh's data into the vertex buffer
        {
            uint32_t currentStartVertex = 0;

            ObjectParameters12 *params = _objectParameters.contents;

            for (int objectIdx = 0; objectIdx < NumObjects12; objectIdx++)
            {
                // Store the mesh metadata in the `params` buffer.
                params[objectIdx].numVertices = tempMeshes[objectIdx].numVerts;

                size_t meshSize = sizeof(Vertex12) * tempMeshes[objectIdx].numVerts;

                params[objectIdx].startVertex = currentStartVertex;

                // Pack the current mesh data in the combined vertex buffer.

                AAPLVertex* meshStartAddress = ((AAPLVertex*)_vertexBuffer.contents) + currentStartVertex;

                memcpy(meshStartAddress, tempMeshes[objectIdx].vertices, meshSize);

                currentStartVertex += tempMeshes[objectIdx].numVerts;

                free(tempMeshes[objectIdx].vertices);

                // Set the other culling and mesh rendering parameters.

                // Set the position of each object to a unique space in a grid.
                vector_float2 gridPos = (vector_float2){objectIdx % AAPLGridWidth, objectIdx / AAPLGridWidth};
                params[objectIdx].position = gridPos * AAPLObjecDistance;

                params[objectIdx].boundingRadius = AAPLObjectSize / 2.0;
            }
        }

        free(tempMeshes);
    }
    return self;
}

// MARK: - Define the Data Read by the ICB
/**
 In an ideal scenario, you store each mesh in its own buffer.
 However, on iOS, kernels running on the GPU can only access a limited number of data buffers per execution.
 To reduce the number of buffers needed during the ICBs execution, you pack all meshes into a single buffer at varying offsets.
 Then, use another buffer to store the offset and size of each mesh. The process to do this follows.
 
 At initialization, create the data for each mesh:
 */
// Create a Metal buffer containing a 2D "gear" mesh (1个齿轮的mesh)
- (ObjectMesh)newGearMeshWithNumTeeth:(uint32_t)numTeeth
                           innerRatio:(float)innerRatio
                           toothWidth:(float)toothWidth
                           toothSlope:(float)toothSlope
{
    NSAssert(numTeeth >= 3, @"Can only build a gear with at least 3 teeth");
    NSAssert(toothWidth + 2 * toothSlope < 1.0, @"Configuration of gear invalid");
    
    ObjectMesh mesh;
    
    /**
     For each tooth, this function generates 2 triangles for tooth itself,
     1 triangle to fill the inner portion of the gear from bottom of the tooth to the center of the gear,
     and 1 triangle to fill the inner portion of the gear below the groove beside the tooth.
     Hence, the buffer needs 4 triangles or 12 vertices for each tooth.
     */
    uint32_t numVertices = numTeeth * 12;
    uint32_t bufferSize = sizeof(Vertex12) * numVertices;
    
    mesh.numVerts = numVertices;
    mesh.vertices = (Vertex12 *)malloc(bufferSize);
    
    const double angle = 2.0 * M_PI / (double)numTeeth;
    static const packed_float2 origin = (packed_float2){0.0, 0.0};
    uint32_t vtx = 0;
    
    // Build triangles for teeth of gear
    for (int tooth = 0; tooth < numTeeth; tooth++)
    {
        // Calculate angles for tooth and groove
        const float toothStartAngle = tooth * angle;
        const float toothTip1Angle  = (tooth+toothSlope) * angle;
        const float toothTip2Angle  = (tooth+toothSlope+toothWidth) * angle;;
        const float toothEndAngle   = (tooth+2*toothSlope+toothWidth) * angle;
        const float nextToothAngle  = (tooth+1.0) * angle;

        // Calculate positions of vertices needed for the tooth
        const packed_float2 groove1    = { sin(toothStartAngle)*innerRatio, cos(toothStartAngle)*innerRatio };
        const packed_float2 tip1       = { sin(toothTip1Angle), cos(toothTip1Angle) };
        const packed_float2 tip2       = { sin(toothTip2Angle), cos(toothTip2Angle) };
        const packed_float2 groove2    = { sin(toothEndAngle)*innerRatio, cos(toothEndAngle)*innerRatio };
        const packed_float2 nextGroove = { sin(nextToothAngle)*innerRatio, cos(nextToothAngle)*innerRatio };

        // groove: 槽 tip: 顶尖
        // Right top triangle of tooth
        mesh.vertices[vtx].position = groove1;
        mesh.vertices[vtx].texcoord = (groove1 + 1.0) / 2.0;
        vtx++;

        mesh.vertices[vtx].position = tip1;
        mesh.vertices[vtx].texcoord = (tip1 + 1.0) / 2.0;
        vtx++;

        mesh.vertices[vtx].position = tip2;
        mesh.vertices[vtx].texcoord = (tip2 + 1.0) / 2.0;
        vtx++;

        // Left bottom triangle of tooth
        mesh.vertices[vtx].position = groove1;
        mesh.vertices[vtx].texcoord = (groove1 + 1.0) / 2.0;
        vtx++;

        mesh.vertices[vtx].position = tip2;
        mesh.vertices[vtx].texcoord = (tip2 + 1.0) / 2.0;
        vtx++;

        mesh.vertices[vtx].position = groove2;
        mesh.vertices[vtx].texcoord = (groove2 + 1.0) / 2.0;
        vtx++;

        // Slice of circle from bottom of tooth to center of gear
        mesh.vertices[vtx].position = origin;
        mesh.vertices[vtx].texcoord = (origin + 1.0) / 2.0;
        vtx++;

        mesh.vertices[vtx].position = groove1;
        mesh.vertices[vtx].texcoord = (groove1 + 1.0) / 2.0;
        vtx++;

        mesh.vertices[vtx].position = groove2;
        mesh.vertices[vtx].texcoord = (groove2 + 1.0) / 2.0;
        vtx++;

        // Slice of circle from the groove to the center of gear
        mesh.vertices[vtx].position = origin;
        mesh.vertices[vtx].texcoord = (origin + 1.0) / 2.0;
        vtx++;

        mesh.vertices[vtx].position = groove2;
        mesh.vertices[vtx].texcoord = (groove2 + 1.0) / 2.0;
        vtx++;

        mesh.vertices[vtx].position = nextGroove;
        mesh.vertices[vtx].texcoord = (nextGroove + 1.0) / 2.0;
        vtx++;
    }

    return mesh;
}

- (void)drawInMTKView:(MTKView *)view {
    NSLog(@"%s", __FUNCTION__);
    
    
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    NSLog(@"%s width = %lf height = %lf", __FUNCTION__, size.width, size.height);
    
    /**
     Calculate scale for quads so that they are always square when working with the default viewport and sending down clip space corrdinates.
     */
    _aspectScale.x = (float)size.height / (float)size.width;
    _aspectScale.y = 1.0;
}

@end
