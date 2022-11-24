//
//  main15.cpp
//  TestOpenGL
//
//  Created by youdun on 2022/11/15.
//

// MARK: - 变换
/**
 我们可以尝试着在每一帧改变物体的顶点并且重配置缓冲区从而使它们移动，但这太繁琐了，而且会消耗很多的处理时间。
 我们现在有一个更好的解决方案，使用（多个）矩阵(Matrix)对象可以更好的变换(Transform)一个物体。
 */

// MARK: - 向量
/**
 向量最基本的定义就是一个方向。
 或者更正式的说，向量有一个方向(Direction)和大小(Magnitude，也叫做强度或长度)。
 你可以把向量想像成一个藏宝图上的指示：“向左走10步，向北走3步，然后向右走5步”；“左”就是方向，“10步”就是向量的长度。
 向量可以在任意维度(Dimension)上，但是我们通常只使用2至4维。如果一个向量有2个维度，它表示一个平面的方向(想象一下2D的图像)，当它有3个维度的时候它可以表达一个3D世界的方向。
 
 每个向量在2D图像中都用一个箭头(x, y)表示。
 你可以把这些2D向量当做z坐标为0的3D向量。由于向量表示的是方向，起始于何处并不会改变它的值。
 
 向量(3, 2)v¯和w¯是相等的，尽管他们的起始点不同
 
 数学家喜欢在字母上面加一横表示向量，比如说v¯
 当用在公式中时它们通常是这样的：
 v¯=(xyz)
 
 由于向量是一个方向，所以有些时候会很难形象地将它们用位置(Position)表示出来。为了让其更为直观，我们通常设定这个方向的原点为(0, 0, 0)，然后指向一个方向，对应一个点，使其变为位置向量(Position Vector)（你也可以把起点设置为其他的点，然后说：这个向量从这个点起始指向另一个点）。
 比如说位置向量(3, 5)在图像中的起点会是(0, 0)，并会指向(3, 5)。我们可以使用向量在2D或3D空间中表示方向与位置.
 */

// MARK: - 向量与标量运算
/**
 标量(Scalar)只是一个数字（或者说是仅有一个分量的向量）。
 当把一个向量加/减/乘/除一个标量，我们可以简单的把向量的每个分量分别进行该运算。对于加法来说会像这样:
 (123)+x=(1+x,2+x,3+x)
 其中的+可以是+，-，·或÷，其中·是乘号。
 数学上是没有向量与标量相加这个运算的，但是很多线性代数的库都对它有支持（比如说我们用的GLM）。
 如果你使用过numpy的话，可以把它理解为Broadcasting。
 */

// MARK: - 向量取反
/**
 对一个向量取反(Negate)会将其方向逆转。一个指向东北的向量取反后就指向西南方向了。我们在一个向量的每个分量前加负号就可以实现取反了（或者说用-1数乘该向量）:

 −v¯=−(vxvyvz)=(−vx−vy−vz)
 */

// MARK: - 向量加减
/**
 向量的加法可以被定义为是分量的(Component-wise)相加，即将一个向量中的每一个分量加上另一个向量的对应分量：

 v¯=(123),k¯=(456)→v¯+k¯=(1+42+53+6)=(579)
 
 向量的减法等于加上第二个向量的相反向量：

 v¯=(123),k¯=(456)→v¯+−k¯=(1+(−4)2+(−5)3+(−6))=(−3−3−3)
 
 两个向量的相减会得到这两个向量指向位置的差。这在我们想要获取两点的差会非常有用。
 */

// MARK: - 长度
/**
 我们使用勾股定理(Pythagoras Theorem)来获取向量的长度(Length)/大小(Magnitude)。如果你把向量的x与y分量画出来，该向量会和x与y分量为边形成一个三角形:
 
 因为两条边（x和y）是已知的，如果希望知道斜边v¯的长度，我们可以直接通过勾股定理来计算：

 ||v¯||=x2+y2√
 ||v¯|| 表示向量v¯的长度
 
 有一个特殊类型的向量叫做单位向量(Unit Vector)。单位向量有一个特别的性质——它的长度是1。
 我们可以用任意向量的每个分量除以向量的长度得到它的单位向量n^：
 n^=v¯/||v¯||
 
 我们把这种方法叫做一个向量的标准化(Normalizing)。单位向量头上有一个^样子的记号。通常单位向量会变得很有用，特别是在我们只关心方向不关心长度的时候（如果改变向量的长度，它的方向并不会改变）。
 */

// MARK: - 向量相乘
/**
 两个向量相乘是一种很奇怪的情况。普通的乘法在向量上是没有定义的，因为它在视觉上是没有意义的。但是在相乘的时候我们有两种特定情况可以选择：一个是点乘(Dot Product)，记作v¯⋅k¯，另一个是叉乘(Cross Product)，记作v¯×k¯。
 
 点乘
 两个向量的点乘等于它们的数乘结果乘以两个向量之间夹角的余弦值。可能听起来有点费解，我们来看一下公式：

 v¯⋅k¯=||v¯||⋅||k¯||⋅cosθ
 它们之间的夹角记作θ。为什么这很有用？想象如果v¯和k¯都是单位向量，它们的长度会等于1。这样公式会有效简化成：

 v¯⋅k¯=1⋅1⋅cosθ=cosθ
 现在点积只定义了两个向量的夹角。你也许记得90度的余弦值是0，0度的余弦值是1。使用点乘可以很容易测试两个向量是否正交(Orthogonal)或平行（正交意味着两个向量互为直角）。
 
 https://www.khanacademy.org/math/geometry-home/right-triangles-topic/intro-to-the-trig-ratios-geo/v/basic-trigonometry
 
 你也可以通过点乘的结果计算两个非单位向量的夹角，点乘的结果除以两个向量的长度之积，得到的结果就是夹角的余弦值，即cosθ。

 译注：通过上面点乘定义式可推出：

 cosθ=v¯⋅k¯/||v¯||⋅||k¯||
 
 点乘是通过将对应分量逐个相乘，然后再把所得积相加来计算的。两个单位向量的（你可以验证它们的长度都为1）点乘会像是这样：

 (0.6−0.80)⋅(010)=(0.6∗0)+(−0.8∗1)+(0∗0)=−0.8
 要计算两个单位向量间的夹角，我们可以使用反余弦函数cos−1 ，可得结果是143.1度。现在我们很快就计算出了这两个向量的夹角。点乘会在计算光照的时候非常有用。
 
 叉乘
 叉乘只在3D空间中有定义，它需要两个不平行向量作为输入，生成一个正交于两个输入向量的第三个向量。
 如果输入的两个向量也是正交的，那么叉乘之后将会产生3个互相正交的向量。
 线性代数
 正交向量A和B叉积：

 (AxAyAz)×(BxByBz)=(Ay⋅Bz−Az⋅ByAz⋅Bx−Ax⋅BzAx⋅By−Ay⋅Bx)
 */

// MARK: - 矩阵
/**
 矩阵就是一个矩形的数字、符号或表达式数组。矩阵中每一项叫做矩阵的元素(Element)。下面是一个2×3矩阵的例子：
 1   2   3
 4  5   6
 矩阵可以通过(i, j)进行索引，i是行，j是列，这就是上面的矩阵叫做2×3矩阵的原因
 （3列2行，也叫做矩阵的维度(Dimension)）
 这与你在索引2D图像时的(x, y)相反，获取4的索引是(2, 1)（第二行，第一列）
 如果是图像索引应该是(1, 2)，先算列，再算行
 矩形的数学表达式阵列
 
 矩阵的加减:
 矩阵与标量之间的加减定义如下：
 1  2           1+3 2+3     4   5
    + 3 =               =
 3  4           3+3 4+3     6   7
 标量值要加到矩阵的每一个元素上。矩阵与标量的减法也相似
 注意，数学上是没有矩阵与标量相加减的运算的，但是很多线性代数的库都对它有支持（比如说我们用的GLM）。
 矩阵与矩阵之间的加减就是两个矩阵对应元素的加减运算，所以总体的规则和与标量运算是差不多的，只不过在相同索引下的元素才能进行运算。
 这也就是说加法和减法只对同维度的矩阵才是有定义的。一个3×2矩阵和一个2×3矩阵（或一个3×3矩阵与4×4矩阵）是不能进行加减的。
 
 矩阵的数乘
 和矩阵与标量的加减一样，矩阵与标量之间的乘法也是矩阵的每一个元素分别乘以该标量。
 现在我们也就能明白为什么这些单独的数字要叫做标量(Scalar)了。简单来说，标量就是用它的值缩放(Scale)矩阵的所有元素
 译注：注意Scalar是由Scale + -ar演变过来的）。前面那个例子中，所有的元素都被放大了2倍。
 
 矩阵相乘
 相乘还有一些限制：
 只有当左侧矩阵的列数与右侧矩阵的行数相等，两个矩阵才能相乘。
 矩阵相乘不遵守交换律(Commutative)，也就是说A⋅B≠B⋅A。
 
 1  2   5   6         1*5+ 2*7  1*6+2*8     19   22
    .           =                                       =
 3  4   7   8         3*5+ 4*7  3*6+4*8     43  50
 
 我们首先把左侧矩阵的行和右侧矩阵的列拿出来。这些挑出来行和列将决定我们该计算结果2x2矩阵的哪个输出值。如果取的是左矩阵的第一行，输出值就会出现在结果矩阵的第一行。接下来再取一列，如果我们取的是右矩阵的第一列，最终值则会出现在结果矩阵的第一列。
 如果想计算结果矩阵右下角的值，我们要用第一个矩阵的第二行和第二个矩阵的第二列（译注：简单来说就是结果矩阵的元素的行取决于第一个矩阵，列取决于第二个矩阵）。
 
 结果矩阵的维度是(n, m)，n等于左侧矩阵的行数，m等于右侧矩阵的列数。
 
 矩阵与向量相乘
 我们用向量来表示位置，表示颜色，甚至是纹理坐标。
 向量，它其实就是一个N×1矩阵，N表示向量分量的个数（也叫N维(N-dimensional)向量）。
 向量和矩阵一样都是一个数字序列，但它只有1列。
 如果我们有一个M×N矩阵，我们可以用这个矩阵乘以我们的N×1向量，因为这个矩阵的列数等于向量的行数，所以它们就能相乘。
 很多有趣的2D/3D变换都可以放在一个矩阵中，用这个矩阵乘以我们的向量将变换(Transform)这个向量。
 
 单位矩阵
 在OpenGL中，由于某些原因我们通常使用4×4的变换矩阵，而其中最重要的原因就是大部分的向量都是4分量的。
 最简单的变换矩阵就是单位矩阵(Identity Matrix)。单位矩阵是一个除了对角线以外都是0的N×N矩阵。
 一个没变换的变换矩阵有什么用？单位矩阵通常是生成其他变换矩阵的起点，如果我们深挖线性代数，这还是一个对证明定理、解线性方程非常有用的矩阵。
 
 缩放
 对一个向量进行缩放(Scaling)就是对向量的长度进行缩放，而保持它的方向不变。
 由于我们进行的是2维或3维操作，我们可以分别定义一个有2或3个缩放变量的向量，每个变量缩放一个轴(x、y或z)。
 我们先来尝试缩放向量v¯=(3,2)。我们可以把向量沿着x轴缩放0.5，使它的宽度缩小为原来的二分之一；我们将沿着y轴把向量的高度缩放为原来的两倍。
 OpenGL通常是在3D空间进行操作的，对于2D的情况我们可以把z轴缩放1倍，这样z轴的值就不变了。
 我们刚刚的缩放操作是不均匀(Non-uniform)缩放，因为每个轴的缩放因子(Scaling Factor)都不一样。如果每个轴的缩放因子都一样那么就叫均匀缩放(Uniform Scale)。
 构造一个变换矩阵来为我们提供缩放功能。
 我们从单位矩阵了解到，每个对角线元素会分别与向量的对应元素相乘。
 如果我们把1变为3会怎样？这样子的话，我们就把向量的每个元素乘以3了，这事实上就把向量缩放3倍
 如果我们把缩放变量表示为(S1,S2,S3)我们可以为任意向量(x,y,z)定义一个缩放矩阵：
 s1  0  0   0       x       s1*x
 0  s2  0   0       y       s2*y
         *      =
 0  0   s3   0      z       s3*z
 0  0   0   1       1       1
 注意，第四个缩放向量仍然是1，因为在3D空间中缩放w分量是无意义的。w分量另有其他用途
 
 位移
 位移(Translation)是在原始向量的基础上加上另一个向量从而获得一个在不同位置的新向量的过程，从而在位移向量基础上移动了原始向量。
 和缩放矩阵一样，在4×4矩阵上有几个特别的位置用来执行特定的操作，对于位移来说它们是第四列最上面的3个值。如果我们把位移向量表示为(Tx,Ty,Tz)，我们就能把位移矩阵定义为
 1  0  0   Tx       x       x+Tx
 0  1  0   Ty        y       y+Ty
         *      =
 0  0   1   Tz      z        z+Tz
 0  0   0   1       1        1
 因为所有的位移值都要乘以向量的w行，所以位移值会加到向量的原始值上
 而如果你用3x3矩阵我们的位移值就没地方放也没地方乘了，所以是不行的。

 齐次坐标(Homogeneous Coordinates)
 向量的w分量也叫齐次坐标。想要从齐次向量得到3D向量，我们可以把x、y和z坐标分别除以w坐标。
 我们通常不会注意这个问题，因为w分量通常是1.0。
 使用齐次坐标有几点好处：它允许我们在3D向量上进行位移（如果没有w分量我们是不能位移向量的），而且我们会用w值创建3D视觉效果。
 如果一个向量的齐次坐标是0，这个坐标就是方向向量(Direction Vector)，因为w坐标是0，这个向量就不能位移
 这也就是我们说的不能位移一个方向
 
 旋转
 旋转矩阵是如何构造出来的:
 https://www.khanacademy.org/math/linear-algebra/matrix_transformations
 2D或3D空间中的旋转用角(Angle)来表示。角可以是角度制或弧度制的，周角是360角度或2 PI弧度。
 大多数旋转函数需要用弧度制的角，但幸运的是角度制的角也可以很容易地转化为弧度制的：
 弧度转角度：角度 = 弧度 * (180.0f / PI)
 角度转弧度：弧度 = 角度 * (PI / 180.0f)
 PI约等于3.14159265359。
 在3D空间中旋转需要定义一个角和一个旋转轴(Rotation Axis)。物体会沿着给定的旋转轴旋转特定角度。
 当2D向量在3D空间中旋转时，我们把旋转轴设为z轴
 使用三角学，给定一个角度，可以把一个向量变换为一个经过旋转的新向量。这通常是使用一系列正弦和余弦函数（一般简称sin和cos）各种巧妙的组合得到的。
 旋转矩阵在3D空间中每个单位轴都有不同定义，旋转角度用θ表示
 沿x轴旋转
 1  0       0       0       x       x
 0  cos  -sin    0        y       cos*y-sin*z
            *      =
 0  sin   cos    0      z        sin*y+cos*z
 0  0       0       1       1        1
 沿y轴旋转
 cos  0    sin  0       x       cos*x+sin*z
 0      1    0    0        y       y
            *      =
 -sin  0   cos    0      z        -sin*x+cos*z
 0      0       0       1       1        1
 沿z轴旋转
 cos   -sin    0   0             x       cos*x-sin*y
 sin    cos    0    0            y       sin*x+cos*y
                *      =
 0      0       1    0              z        z
 0      0       0      1           1        1
 利用旋转矩阵我们可以把任意位置向量沿一个单位旋转轴进行旋转。
 也可以将多个矩阵复合，比如先沿着x轴旋转再沿着y轴旋转。
 但是这会很快导致一个问题——万向节死锁(Gimbal Lock)
 https://www.youtube.com/watch?v=zc8b2Jo7mno
 https://v.youku.com/v_show/id_XNzkyOTIyMTI=.html
 避免万向节死锁的真正解决方案是使用四元数(Quaternion)，它不仅更安全，而且计算会更有效率。
 如果你想了解四元数与3D旋转之间的关系
 https://krasjet.github.io/quaternion/quaternion.pdf
 https://krasjet.github.io/quaternion/bonus_gimbal_lock.pdf
 
 采用球极平面投影(Stereographic Projection)的方式将四元数投影到3D空间，同样有助于理解四元数的概念
 https://www.youtube.com/watch?v=d4EgbgTm0Bg
 
 矩阵的组合
 根据矩阵之间的乘法，我们可以把多个变换组合到一个矩阵中
 假设我们有一个顶点(x, y, z)，我们希望将其缩放2倍，然后位移(1, 2, 3)个单位。我们需要一个位移和缩放矩阵来完成这些变换。
            1  0  0   1             2   0   0   0       2   0   0   1
            0  1  0   2             0   2   0   0       0   2   0   2
Trans.Scale=                          *                         =
            0  0   1   3            0   0   2   0        0  0   2   3
            0  0   0   1            0   0   0   1       0   0   0   1
 当矩阵相乘时我们先写位移再写缩放变换的。矩阵乘法是不遵守交换律的，这意味着它们的顺序很重要。
 当矩阵相乘时，在最右边的矩阵是第一个与向量相乘的，所以你应该从右向左读这个乘法。建议您在组合矩阵时，先进行缩放操作，然后是旋转，最后才是位移，否则它们会（消极地）互相影响。
 比如，如果你先位移再缩放，位移的向量也会同样被缩放（译注：比如向某方向移动2米，2米也许会被缩放成1米）！
 用最终的变换矩阵左乘我们的向量会得到以下结果：
 2   0    0   1          x       2*x+1
 0   2   0    2          y       2*y+2
            *      =
 0    0    2   3          z       2*z+3
 0    0    0   1          1       1
 向量先缩放2倍，然后位移了(1, 2, 3)个单位。
 
 线性代数的本质:讨论了变换和线性代数内在的数学本质
 https://www.youtube.com/playlist?list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab
 https://space.bilibili.com/88461692#!/channel/detail?cid=9450
 */

// MARK: - GLM
/**
 有个易于使用，专门为OpenGL量身定做的数学库，那就是GLM。
 GLM是OpenGL Mathematics的缩写，它是一个只有头文件的库，也就是说我们只需包含对应的头文件就行了，不用链接和编译。
 https://glm.g-truc.net/0.9.8/index.html
 
 GLM库从0.9.9版本起，默认会将矩阵类型初始化为一个零矩阵（所有元素均为0），而不是单位矩阵（对角元素为1，其它元素为0）。如果你使用的是0.9.9或0.9.9以上的版本，你需要将所有的矩阵初始化改为 glm::mat4 mat = glm::mat4(1.0f)。请使用低于0.9.9版本的GLM，或者改用上述代码初始化所有的矩阵。
 我们需要的GLM的大多数功能都可以从下面这3个头文件中找到：

 #include <glm/glm.hpp>
 #include <glm/gtc/matrix_transform.hpp>
 #include <glm/gtc/type_ptr.hpp>
 
 把一个向量(1, 0, 0)位移(1, 1, 0)个单位.注意，我们把它定义为一个glm::vec4类型的值，齐次坐标设定为1.0）
 glm::vec4 vec(1.0f, 0.0f, 0.0f, 1.0f);
 // 译注：下面就是矩阵初始化的一个例子，如果使用的是0.9.9及以上版本
 // 下面这行代码就需要改为:
 // glm::mat4 trans = glm::mat4(1.0f)
 // 之后将不再进行提示
 glm::mat4 trans;
 trans = glm::translate(trans, glm::vec3(1.0f, 1.0f, 0.0f));
 vec = trans * vec;
 std::cout << vec.x << vec.y << vec.z << std::endl;
 
 我们先用GLM内建的向量类定义一个叫做vec的向量。接下来定义一个mat4类型的trans，默认是一个4×4单位矩阵。
 下一步是创建一个变换矩阵，我们是把单位矩阵和一个位移向量传递给glm::translate函数来完成这个工作的（然后用给定的矩阵乘以位移矩阵就能获得最后需要的矩阵）。 之后我们把向量乘以位移矩阵并且输出最后的结果。
 如果你仍记得位移矩阵是如何工作的话，得到的向量应该是(1 + 1, 0 + 1, 0 + 0)，也就是(2, 1, 0)。
 
 首先我们把箱子逆时针旋转90度。然后缩放0.5倍，使它变成原来的一半大。我们先来创建变换矩阵：
 glm::mat4 trans;
 trans = glm::rotate(trans, glm::radians(90.0f), glm::vec3(0.0, 0.0, 1.0));
 trans = glm::scale(trans, glm::vec3(0.5, 0.5, 0.5));
 
 首先，我们把箱子在每个轴都缩放到0.5倍，然后沿z轴旋转90度。GLM希望它的角度是弧度制的(Radian)，所以我们使用glm::radians将角度转化为弧度。
 如何把矩阵传递给着色器？我们在前面简单提到过GLSL里也有一个mat4类型。所以我们将修改顶点着色器让其接收一个mat4的uniform变量，然后再用矩阵uniform乘以位置向量
 #version 330 core
 layout (location = 0) in vec3 aPos;
 layout (location = 1) in vec2 aTexCoord;

 out vec2 TexCoord;

 uniform mat4 transform;

 void main()
 {
     gl_Position = transform * vec4(aPos, 1.0f);
     TexCoord = vec2(aTexCoord.x, 1.0 - aTexCoord.y);
 }
 GLSL也有mat2和mat3类型从而允许了像向量一样的混合运算。前面提到的所有数学运算（像是标量-矩阵相乘，矩阵-向量相乘和矩阵-矩阵相乘）在矩阵类型里都可以使用。
 
 需要把变换矩阵传递给着色器：
 unsigned int transformLoc = glGetUniformLocation(ourShader.ID, "transform");
 glUniformMatrix4fv(transformLoc, 1, GL_FALSE, glm::value_ptr(trans));
 
 我们首先查询uniform变量的地址，然后用有Matrix4fv后缀的glUniform函数把矩阵数据发送给着色器。
 第一个参数你现在应该很熟悉了，它是uniform的位置值。第二个参数告诉OpenGL我们将要发送多少个矩阵，这里是1。第三个参数询问我们是否希望对我们的矩阵进行转置(Transpose)，也就是说交换我们矩阵的行和列。OpenGL开发者通常使用一种内部矩阵布局，叫做列主序(Column-major Ordering)布局。GLM的默认布局就是列主序，所以并不需要转置矩阵，我们填GL_FALSE。
 最后一个参数是真正的矩阵数据，但是GLM并不是把它们的矩阵储存为OpenGL所希望接受的那种，因此我们要先用GLM的自带的函数value_ptr来变换这些数据。
 我们创建了一个变换矩阵，在顶点着色器中声明了一个uniform，并把矩阵发送给了着色器，着色器会变换我们的顶点坐标。
 我们是否可以让箱子随着时间旋转，我们还会重新把箱子放在窗口的右下角。要让箱子随着时间推移旋转，我们必须在游戏循环中更新变换矩阵，因为它在每一次渲染迭代中都要更新。我们使用GLFW的时间函数来获取不同时间的角度：

 glm::mat4 trans;
 trans = glm::translate(trans, glm::vec3(0.5f, -0.5f, 0.0f));
 trans = glm::rotate(trans, (float)glfwGetTime(), glm::vec3(0.0f, 0.0f, 1.0f));
 
 在这里我们先把箱子围绕原点(0, 0, 0)旋转，之后，我们把旋转过后的箱子位移到屏幕的右下角。记住，实际的变换顺序应该与阅读顺序相反
 尽管在代码中我们先位移再旋转，实际的变换却是先应用旋转再是位移的。
 为什么矩阵在图形领域是一个如此重要的工具了
 */

#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <stb_image/stb_image.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include <utils/shader_s.h>

#include <iostream>

void framebuffer_size_callback(GLFWwindow* window, int width, int height);
void processInput(GLFWwindow *window);

// settings
const unsigned int SCR_WIDTH = 800;
const unsigned int SCR_HEIGHT = 600;

int main()
{
    // glfw: initialize and configure
    // ------------------------------
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

#ifdef __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif

    // glfw window creation
    // --------------------
    GLFWwindow* window = glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, "TestOpenGL", NULL, NULL);
    if (window == NULL)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

    // glad: load all OpenGL function pointers
    // ---------------------------------------
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }

    // build and compile our shader zprogram
    // ------------------------------------
    Shader ourShader("/Users/youdun-ndl/Desktop/iOS/OpenGL/LearnOpenGL_CN/TestOpenGL/TestOpenGL/shaders/15.shader.vs", "/Users/youdun-ndl/Desktop/iOS/OpenGL/LearnOpenGL_CN/TestOpenGL/TestOpenGL/shaders/15.shader.fs");

    // set up vertex data (and buffer(s)) and configure vertex attributes
    // ------------------------------------------------------------------
    float vertices[] = {
        // positions          // texture coords
         0.5f,  0.5f, 0.0f,   1.0f, 1.0f, // top right
         0.5f, -0.5f, 0.0f,   1.0f, 0.0f, // bottom right
        -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, // bottom left
        -0.5f,  0.5f, 0.0f,   0.0f, 1.0f  // top left
    };
    unsigned int indices[] = {
        0, 1, 3, // first triangle
        1, 2, 3  // second triangle
    };
    unsigned int VBO, VAO, EBO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    glGenBuffers(1, &EBO);

    glBindVertexArray(VAO);

    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

    // position attribute
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    // texture coord attribute
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);


    // load and create a texture
    // -------------------------
    unsigned int texture1, texture2;
    // texture 1
    // ---------
    glGenTextures(1, &texture1);
    glBindTexture(GL_TEXTURE_2D, texture1);
    // set the texture wrapping parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    // set texture filtering parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // load image, create texture and generate mipmaps
    int width, height, nrChannels;
    stbi_set_flip_vertically_on_load(true); // tell stb_image.h to flip loaded texture's on the y-axis.
    unsigned char *data = stbi_load("/Users/youdun-ndl/Desktop/iOS/OpenGL/LearnOpenGL_CN/TestOpenGL/TestOpenGL/resources/textures/container.jpg", &width, &height, &nrChannels, 0);
    if (data)
    {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, data);
        glGenerateMipmap(GL_TEXTURE_2D);
    }
    else
    {
        std::cout << "Failed to load texture" << std::endl;
    }
    stbi_image_free(data);
    // texture 2
    // ---------
    glGenTextures(1, &texture2);
    glBindTexture(GL_TEXTURE_2D, texture2);
    // set the texture wrapping parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    // set texture filtering parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // load image, create texture and generate mipmaps
    data = stbi_load("/Users/youdun-ndl/Desktop/iOS/OpenGL/LearnOpenGL_CN/TestOpenGL/TestOpenGL/resources/textures/awesomeface.png", &width, &height, &nrChannels, 0);
    if (data)
    {
        // note that the awesomeface.png has transparency and thus an alpha channel, so make sure to tell OpenGL the data type is of GL_RGBA
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
        glGenerateMipmap(GL_TEXTURE_2D);
    }
    else
    {
        std::cout << "Failed to load texture" << std::endl;
    }
    stbi_image_free(data);

    // tell opengl for each sampler to which texture unit it belongs to (only has to be done once)
    // -------------------------------------------------------------------------------------------
    ourShader.use();
    ourShader.setInt("texture1", 0);
    ourShader.setInt("texture2", 1);


    // render loop
    // -----------
    while (!glfwWindowShouldClose(window))
    {
        // input
        // -----
        processInput(window);

        // render
        // ------
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);

        // bind textures on corresponding texture units
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, texture1);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, texture2);

        // create transformations
        glm::mat4 transform = glm::mat4(1.0f); // make sure to initialize matrix to identity matrix first
        transform = glm::translate(transform, glm::vec3(0.5f, -0.5f, 0.0f));
        transform = glm::rotate(transform, (float)glfwGetTime(), glm::vec3(0.0f, 0.0f, 1.0f));
        /*
        transform = glm::rotate(transform, (float)glfwGetTime(), glm::vec3(0.0f, 0.0f, 1.0f)); // switched the order
        transform = glm::translate(transform, glm::vec3(0.5f, -0.5f, 0.0f)); // switched the order
         */

        // get matrix's uniform location and set matrix
        ourShader.use();
        unsigned int transformLoc = glGetUniformLocation(ourShader.ID, "transform");
        glUniformMatrix4fv(transformLoc, 1, GL_FALSE, glm::value_ptr(transform));

        // render container
        glBindVertexArray(VAO);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);

        // glfw: swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
        // -------------------------------------------------------------------------------
        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    // optional: de-allocate all resources once they've outlived their purpose:
    // ------------------------------------------------------------------------
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
    glDeleteBuffers(1, &EBO);

    // glfw: terminate, clearing all previously allocated GLFW resources.
    // ------------------------------------------------------------------
    glfwTerminate();
    return 0;
}

// process all input: query GLFW whether relevant keys are pressed/released this frame and react accordingly
// ---------------------------------------------------------------------------------------------------------
void processInput(GLFWwindow *window)
{
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
        glfwSetWindowShouldClose(window, true);
}

// glfw: whenever the window size changed (by OS or user resize) this callback function executes
// ---------------------------------------------------------------------------------------------
void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
    // make sure the viewport matches the new window dimensions; note that width and
    // height will be significantly larger than specified on retina displays.
    glViewport(0, 0, width, height);
}
