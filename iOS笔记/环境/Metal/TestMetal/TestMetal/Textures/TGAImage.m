//
//  MTLImage.m
//  TestMetal
//
//  Created by youdun on 2023/8/28.
//

#import "TGAImage.h"

// https://en.wikipedia.org/wiki/Truevision_TGA#Header
// Structure fitting the layout of a TGA header containing image metadata.
typedef struct __attribute__ ((packed)) TGAHeader {
    uint8_t IDSize;          // Size of ID info following header
    uint8_t colorMapType;    // Whether this is a paletted image
    uint8_t imageType;       // type of image 0=none, 1=indexed, 2=rgb, 3=grey, +8=rle packed
    
    int16_t colorMapStart;   // Offset to color map in palette
    int16_t colorMapLength;  // Number of colors in palette
    uint8_t colorMapBpp;     // Number of bits per palette entry
    
    uint16_t xOrigin;        // X Origin pixel of lower left corner if tile of larger image
    uint16_t yOrigin;        // Y Origin pixel of lower left corner if tile of larger image
    uint16_t width;          // Width in pixels
    uint16_t height;         // Height in pixels
    uint8_t bitsPerPixel;    // Bits per pixel 8,16,24,32
    
    // Bit 4 of the image descriptor byte indicates right-to-left pixel ordering if set. Bit 5 indicates an ordering of top-to-bottom. Otherwise, pixels are stored in bottom-to-top, left-to-right order.
    union __attribute__ ((packed)) {
        struct __attribute__ ((packed))
        {
            uint8_t bitsPerAlpha : 4;
            uint8_t topOrigin    : 1;
            uint8_t rightOrigin  : 1;
            uint8_t reserved     : 2;
        };
        uint8_t descriptor;
    };
} TGAHeader;

@implementation TGAImage

// MARK: - Load and Format Image Data
/**
 You can create a texture or update its contents manually.
 You might do this for multiple reasons:
 You have image data stored in a custom format.
 You have textures whose contents need to be generated at runtime.
 You are streaming texture data from a server or otherwise need to dynamically update a texture’s contents.
 
 In the sample, the MTLImage class loads and parses image data from TGA files.
 The class converts pixel data from the TGA file into a pixel format that Metal understands.
 The sample uses the image’s metadata to create a new Metal texture and copies the pixel data into the texture.

 Note
 The MTLImage class isn’t the focal point of this sample, so it isn’t discussed in detail.
 The class demonstrates basic image loading operations but doesn’t use or depend on the Metal framework.
 Its sole purpose is to facilitate loading image data and converting it into a Metal pixel format.
 You might create a similar class if you need to load an image that’s in a custom format.
 
 Metal requires all textures to be formatted with a specific MTLPixelFormat value.
 The pixel format describes the layout of pixel data in the texture.
 This sample uses the MTLPixelFormatBGRA8Unorm pixel format, which uses 32 bits per pixel, arranged into 8 bits per component, in blue, green, red, and alpha order:
 
 Before you can populate a Metal texture, you must format the image data into the texture’s pixel format.
 TGA files can provide pixel data either in a 32-bit-per-pixel format or a 24-bit-per-pixel format.
 TGA files that use 32 bits per pixel are already arranged in this format, so you just copy the pixel data.
 To convert a 24-bit-per-pixel BGR image, copy the red, green, and blue channels and set the alpha channel to 255, indicating a fully opaque pixel.


 
 For 2D textures, normalized texture coordinates are values from 0.0 to 1.0 in both x and y directions.
 A value of (0.0, 0.0) specifies the texel at the first byte of the texture data (the top-left corner of the image).
 A value of (1.0, 1.0) specifies the texel at the last byte of the texture data (the bottom-right corner of the image).
 
 
 "Origin in lower left-hand corner" 是一个常见的图形学概念，指的是坐标系原点（Origin）位于图像或屏幕的左下角。
 这种坐标系被称为左下角坐标系（或下左坐标系），在这种坐标系中，X 轴正方向是向右，Y 轴正方向是向上。
 
 "Origin in upper left-hand corner" 是一个图形学概念，指的是坐标系原点（Origin）位于图像或屏幕的左上角。
 这种坐标系被称为左上角坐标系（或上左坐标系），在这种坐标系中，X 轴正方向是向右，Y 轴正方向是向下。
 */

/**
 因为 TGA 文件格式要求头部的数据按照严格的字节顺序紧凑排列，以确保文件解析的正确性。
 TGA 文件头部的结构是由规范定义的，需要严格按照规定的格式存储数据。
 typedef struct __attribute__ ((packed)) TGAHeader {
 
 }TGAHeader;
 
 __attribute__ ((packed)) 是一个编译器特定的属性（attribute），用于告诉编译器不要对结构体进行字节对齐（alignment）。
 结构体在内存中通常会被编译器按照特定的字节对齐规则进行排列，以提高访问效率，但有时候可能需要在某些情况下禁用这种字节对齐。
 
 这意味着在内存中，这个结构体的成员不会按照默认的字节对齐规则进行排列，而是紧凑地存储在一起，节省内存空间。
 这对于某些特定的文件格式或硬件要求非常有用，但也可能会导致访问效率的降低。
 */

- (nullable instancetype)initWithTGAFileFromUrl:(nonnull NSURL *)url {
    self = [super init];
    if (self) {
        NSString *fileExtension = url.pathExtension;
        if (!([fileExtension caseInsensitiveCompare:@"TGA"] == NSOrderedSame)) {
            NSLog(@"This image loader only loads TGA files");
            return nil;
        }
        
        NSError *error = nil;
        // Copy the entire file to this fileData variable
        NSData *fileData = [[NSData alloc] initWithContentsOfURL:url
                                                         options:0x0
                                                           error:&error];
        
        if (!fileData) {
            NSLog(@"Could not open TGA File: %@", error.localizedDescription);
            return nil;
        }
        
        TGAHeader *tgaInfo = (TGAHeader *)fileData.bytes;
        
        if (tgaInfo->imageType != 2) {
            NSLog(@"This image loader only supports non-compressed BGR(A) TGA files");
            return nil;
        }
        
        /**
         TGA 文件格式支持两种类型的图像：直接颜色图像（Truecolor Image）和索引颜色图像（Indexed Image）。
         对于索引颜色图像，文件中存储的并不是每个像素的真实颜色值，而是一个索引，该索引对应于颜色映射表中的某个颜色。
         */
        if (tgaInfo->colorMapType) {
            NSLog(@"This image loader doesn't support TGA files with a colormap");
            return nil;
        }
        
        if (tgaInfo->xOrigin || tgaInfo->yOrigin)
        {
            NSLog(@"This image loader doesn't support TGA files with a non-zero origin");
            return nil;
        }
        
        NSUInteger srcBytesPerPixel;
        if (tgaInfo->bitsPerPixel == 32) {
            srcBytesPerPixel = 4;
            
            if (tgaInfo->bitsPerAlpha != 8) {
                NSLog(@"This image loader only supports 32-bit TGA files with 8 bits of alpha");
                return nil;
            }
            
        } else if(tgaInfo->bitsPerPixel == 24) {
            srcBytesPerPixel = 3;
            
            if (tgaInfo->bitsPerAlpha != 0) {
                NSLog(@"This image loader only supports 24-bit TGA files with no alpha");
                return nil;
            }
        } else {
            NSLog(@"This image loader only supports 24-bit and 32-bit TGA files");
            return nil;
        }
        
        _width = tgaInfo->width;
        _height = tgaInfo->height;
        
        // The image data is stored as 32-bits per pixel BGRA data.
        NSUInteger dataSize = _width * _height * 4;
        
        // Metal will not understand an image with 24-bit BGR format so the pixels are converted to a 32-bit BGRA format that Metal does understand (MTLPixelFormatBGRA8Unorm)
        NSMutableData *mutableData = [[NSMutableData alloc] initWithLength:dataSize];
        
        /**
         TGA spec says the image data is immediately after the header and the ID so set the pointer to file's start + size of the header + size of the ID Initialize a source pointer with the source image data that's in BGR form
         */
        uint8_t *srcImageData = ((uint8_t *)fileData.bytes +
                                 sizeof(TGAHeader) +
                                 tgaInfo->IDSize);
        
        // Initialize a destination pointer to which you'll store the converted BGRA image data
        uint8_t *dstImageData = mutableData.mutableBytes;

        // For every row of the image
        for(NSUInteger y = 0; y < _height; y++)
        {
            // If bit 5 of the descriptor is not set, flip vertically to transform the data to Metal's top-left texture origin
            NSUInteger srcRow = (tgaInfo->topOrigin) ? y : _height - 1 - y;

            // For every column of the current row
            for(NSUInteger x = 0; x < _width; x++)
            {
                // If bit 4 of the descriptor is set, flip horizontally to transform the data to Metal's top-left texture origin
                NSUInteger srcColumn = (tgaInfo->rightOrigin) ? _width - 1 - x : x;

                // Calculate the index for the first byte of the pixel you're converting in both the source and destination images
                NSUInteger srcPixelIndex = srcBytesPerPixel * (srcRow * _width + srcColumn);
                NSUInteger dstPixelIndex = 4 * (y * _width + x);

                // Copy BGR channels from the source to the destination. Set the alpha channel of the destination pixel to 255
                dstImageData[dstPixelIndex + 0] = srcImageData[srcPixelIndex + 0];
                dstImageData[dstPixelIndex + 1] = srcImageData[srcPixelIndex + 1];
                dstImageData[dstPixelIndex + 2] = srcImageData[srcPixelIndex + 2];

                if(tgaInfo->bitsPerPixel == 32) {
                    dstImageData[dstPixelIndex + 3] =  srcImageData[srcPixelIndex + 3];
                } else {
                    dstImageData[dstPixelIndex + 3] = 255;
                }
            }
        }
        
        _data = mutableData;
    }
    return self;
}

- (nullable instancetype)initWithBGRA8UnormData:(nonnull NSData *)data
                                          width:(NSUInteger)width
                                         height:(NSUInteger)height {
    self = [super init];
    if (self) {
        if (data.length < 4 * width * height)
        {
            NSLog(@"The data provided isn't large enough to hold an image with %dx%d BGRA8Unorm pixels.",
                  (uint32_t)_width,
                  (uint32_t)_height);
            return nil;
        }
        _data = data;
        _width = width;
        _height = height;
    }
    return self;
}

- (void)saveToTGAFileAtLocation:(nonnull NSURL *)location {
    NSMutableData *data = [[NSMutableData alloc] initWithLength:sizeof(TGAHeader)];
    TGAHeader *tgaInfo = (TGAHeader *)data.mutableBytes;
    
    tgaInfo->IDSize         = 0;
    tgaInfo->colorMapType   = 0;
    tgaInfo->imageType      = 2;

    tgaInfo->colorMapStart  = 0;
    tgaInfo->colorMapLength = 0;
    tgaInfo->colorMapBpp    = 0;

    tgaInfo->xOrigin        = 0;
    tgaInfo->yOrigin        = 0;
    tgaInfo->width          = _width;
    tgaInfo->height         = _height;
    tgaInfo->bitsPerPixel   = 32;
    tgaInfo->bitsPerAlpha   = 8;
    tgaInfo->rightOrigin    = 0;
    tgaInfo->topOrigin      = 1;
    tgaInfo->reserved       = 0;

    [data appendData:_data];
    
    BOOL ok = [data writeToURL:location atomically:NO];

    if (ok == NO) {
        NSAssert(ok == YES, @"Error writing to @s\n", location);
    }
}

@end
