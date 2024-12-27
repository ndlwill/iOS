//
//  Utilities.swift
//  TestAR
//
//  Created by youdun on 2024/12/25.
//

import SceneKit

extension SCNMatrix4 {
    /*                      |------------------ CGAffineTransformComponents ----------------|
     *
     *      | a  b  0 |     | sx  0  0 |   |  1  0  0 |   | cos(t)  sin(t)  0 |   | 1  0  0 |
     *      | c  d  0 |  =  |  0 sy  0 | * | sh  1  0 | * |-sin(t)  cos(t)  0 | * | 0  1  0 |
     *      | tx ty 1 |     |  0  0  1 |   |  0  0  1 |   |   0       0     1 |   | tx ty 1 |
     *  CGAffineTransform      scale           shear            rotation          translation
     */
    
    /**
     Create a 4x4 matrix from CGAffineTransform, which represents a 3x3 matrix
     but stores only the 6 elements needed for 2D affine transformations.
     
     为了将二维仿射变换应用到三维空间中，我们需要在二维矩阵中添加一维，用于处理 Z 轴方向的变换
     
     [ a  b  0 ]     [ a  b  0  0 ]
     [ c  d  0 ]  -> [ c  d  0  0 ]
     [ tx ty 1 ]     [ 0  0  1  0 ]
     .               [ tx ty 0  1 ]
     
     扩展后的含义：
     二维内容保持不变：
     X 和 Y 方向的缩放、旋转和平移操作（来自二维矩阵部分）保持不变。
     新增的第三维（Z 轴）：
     第三行增加了 Z 轴分量。这里设为单位矩阵的形式[0,0,1,0]，表示在 Z 轴上没有缩放或旋转。
     四维齐次坐标：
     第四列用于处理齐次坐标的平移变换。
     tx 和 ty 表示 X 和 Y 方向的平移，Z 方向的平移为 0。
     
     Used for transforming texture coordinates in the shader modifier.
     (Needs to be SCNMatrix4, not SIMD float4x4, for passing to shader modifier via KVC.)
     
     在 3D 图形（如 SceneKit、ARKit）中，变换通常用 4x4 矩阵表示，以支持三维的平移、缩放、旋转和透视投影。
     为了让二维变换兼容三维系统，需要将 2D 的 CGAffineTransform 嵌入到一个 4x4 矩阵中。
     在 3D 空间中，二维仿射变换只会影响平面上的操作，不会引入任何 z 方向的变化或透视效果。
     */
    init(_ affineTransform: CGAffineTransform) {
        self.init()
        m11 = Float(affineTransform.a)
        m12 = Float(affineTransform.b)
        m21 = Float(affineTransform.c)
        m22 = Float(affineTransform.d)
        m41 = Float(affineTransform.tx)
        m42 = Float(affineTransform.ty)
        m33 = 1
        m44 = 1
    }
}

extension SCNReferenceNode {
    convenience init(named resourceName: String, loadImmediately: Bool = true) {
        let url = Bundle.main.url(forResource: resourceName,
                                  withExtension: "scn",
                                  subdirectory: "Models.scnassets")!
        self.init(url: url)!
        if loadImmediately {
            self.load()
        }
    }
}

extension SCNMaterial {
    static func materialWithColor(_ color: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = color
        return material
    }
}

extension UUID {
    /**
    Pseudo-randomly return one of the 14 fixed standard colors, based on this UUID.
    */
    func toRandomColor() -> UIColor {
        let colors: [UIColor] = [.red,
                                 .green,
                                 .blue,
                                 .yellow,
                                 .magenta,
                                 .cyan,
                                 .purple,
                                 .orange,
                                 .brown,
                                 .lightGray,
                                 .gray,
                                 .darkGray,
                                 .black,
                                 .white]
        let randomNumber = abs(self.hashValue % colors.count)
        return colors[randomNumber]
    }
}
