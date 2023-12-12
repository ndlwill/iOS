//
//  Utils.swift
//  TestAR
//
//  Created by youdun on 2023/8/17.
//

import ARKit

// MARK: - UIColor
extension UIColor {
    static let planeColor = UIColor(named: "PlaneColor") ?? UIColor.yellow
    static let planeMeshColor = UIColor(named: "PlaneMeshColor") ?? UIColor.yellow
    static let planeExtentColor = UIColor(named: "PlaneExtentColor") ?? UIColor.red
}

// MARK: - ARPlaneAnchor.Classification
@available(iOS 12.0, *)
extension ARPlaneAnchor.Classification: CustomStringConvertible {
    public var description: String {
        switch self {
        case .wall:
            return "Wall"
        case .floor:
            return "Floor"
        case .ceiling:
            return "Ceiling"
        case .table:
            return "Table"
        case .seat:
            return "Seat"
        case .window:
            return "Window"
        case .door:
            return "Door"
        case .none(.notAvailable):
            return "NotAvailable"
        case .none(.undetermined):
            return "Undetermined"
        case .none(.unknown):
            return "Unknown"
        default:
            return ""
        }
    }
}

// MARK: - SCNNode
extension SCNNode {
    func centerAlign() {
        let (min, max) = self.boundingBox
        let extents = SIMD3<Float>(max) - SIMD3<Float>(min)
        self.simdPivot = float4x4(translation: ((extents / 2) + SIMD3<Float>(min)))
    }
}

// MARK: - float4x4
extension float4x4 {
    init(translation vector: SIMD3<Float>) {
        self.init(SIMD4(1, 0, 0, 0),
                  SIMD4(0, 1, 0, 0),
                  SIMD4(0, 0, 1, 0),
                  SIMD4(vector.x, vector.y, vector.z, 1))
    }
}
