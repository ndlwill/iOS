# DHVectorDiagram

## Description

用来构造一个抽象的2D矢量图

可进行平移、缩放、旋转

可渲染到一个视图上

也可以直接使用我自己简单的封装的DHVectorDiagramView来绘制一个矢量图

所有对矢量图的变形操作只操作了构成矢量图的点，不会对渲染矢量图的那个视图产生任何影响

由于只对点进行了操作，所以缩放不会影响线宽，旋转不会造成锯齿;)

里面的DHMatrix是矩阵结构体，为了解决矢量图的各种变形算法而设计出来的，暂时只有乘法，可用于其他地方

## Usage

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 正七边形
    DHVectorDiagram * diagram = [DHVectorDiagram regularPolygon:7 edgeLength:1];
    diagram.unitLength = 50;
    [diagram translateWithDeltaX:2 deltaY:2];
    DHVectorDiagramView * view = [[DHVectorDiagramView alloc] initWithFrame:self.view.bounds vectorDiagram:diagram];
    [self.view addSubview:view];
    
    // 五角星
    diagram = [DHVectorDiagram pentastarWithLength:1];
    diagram.unitLength = 50;
    [diagram translateWithDeltaX:5 deltaY:2];
    [diagram rotateWithRadian:36.f/180 * M_PI];
    
    view = [[DHVectorDiagramView alloc] initWithFrame:self.view.bounds vectorDiagram:diagram];
    [self.view addSubview:view];
    
    // 凸
    NSValue * point1 = [NSValue valueWithCGPoint:CGPointMake(-1, -2)];
    NSValue * point2 = [NSValue valueWithCGPoint:CGPointMake(1, -2)];
    NSValue * point3 = [NSValue valueWithCGPoint:CGPointMake(1, -1)];
    NSValue * point4 = [NSValue valueWithCGPoint:CGPointMake(2, -1)];
    NSValue * point5 = [NSValue valueWithCGPoint:CGPointMake(2, 1)];
    NSValue * point6 = [NSValue valueWithCGPoint:CGPointMake(-2, 1)];
    NSValue * point7 = [NSValue valueWithCGPoint:CGPointMake(-2, -1)];
    NSValue * point8 = [NSValue valueWithCGPoint:CGPointMake(-1, -1)];
    
    NSArray * points = @[point1,point2,point3,point4,point5,point6,point7,point8];

    DHVectorDiagram * vectorDiagram = [[DHVectorDiagram alloc] initWithVertexBuffers:points];
    vectorDiagram.unitLength = 50;
    
    // 施加各种变形操作
    [vectorDiagram translateWithDeltaX:3 deltaY:5];
    [vectorDiagram rotateWithRadian:M_PI_2];
    [vectorDiagram scaleWithScalingFactorX:1 scalingFactorY:2];

    [vectorDiagram translateWithDeltaX:0 deltaY:4];
    [vectorDiagram rotateWithRadian:M_PI_4];
    [vectorDiagram scaleWithScalingFactorX:2 scalingFactorY:1];

    view = [[DHVectorDiagramView alloc] initWithFrame:self.view.bounds vectorDiagram:vectorDiagram];
    [self.view addSubview:view];
    
}

```

![1](https://github.com/DHUsesAll/GitImages/blob/master/DHVectorDiagram/1.png)
