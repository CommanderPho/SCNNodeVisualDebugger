//
// Copyright © 2017 Handsome.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
/////////////////////////////////////////////////////////////////////////////

import Foundation
import SceneKit

#if os(macOS)
    typealias SCNColor = NSColor
	typealias SCNImage = NSImage
	typealias SCNTouch = NSTouch
	typealias SCNEvent = NSEvent
	typealias SCNFont = NSFont

#else
    typealias SCNColor = UIColor
	typealias SCNImage = UIImage
	typealias SCNTouch = UITouch
	typealias SCNEvent = UIEvent
	typealias SCNFont = NSFont
#endif


//MARK: AxesSettings
protocol AxesSettings {
    var axisSize: AxisSize { get }
    var geometry: SCNGeometry { get }
    var colors: AxesColors { get }
    var name: String { get }
    var transform: SCNMatrix4 { get }
}


//MARK: AuxiliaryAxesSettings
fileprivate protocol AuxiliaryAxesSettings {
    static var defaultAxesSizeValue: SCNFloat { get }
    static var sizeValueInFractionsOfNodeSize: SCNFloat { get }
    
    static func makeAxisSize(from nodeSize: SCNFloat, length: SCNFloat) -> AxisSize
}


//MARK: AuxiliaryAxesSettings Default Implementation
extension AuxiliaryAxesSettings {
    static func makeAxisSize(from nodeSize: SCNFloat, length: SCNFloat) -> AxisSize {
        let size = min(nodeSize * sizeValueInFractionsOfNodeSize, defaultAxesSizeValue)
        return AxisSize(width: size, length: length, depth: size)
    }
}


//MARK: AxesColors
struct AxesColors {
    let x: SCNColor
    let y: SCNColor
    let z: SCNColor
}


//MARK: AxisSize
struct AxisSize {
    let width: SCNFloat
    let length: SCNFloat
    let depth: SCNFloat
}


//MARK: LocalAxesSettings
struct LocalAxesSettings: AxesSettings, AuxiliaryAxesSettings {
    static let defaultAxesSizeValue: SCNFloat = 0.1
    static let sizeValueInFractionsOfNodeSize: SCNFloat = 0.01
    
    let axisSize: AxisSize
    let geometry: SCNGeometry
    let name: String = CoordinateSystem.local
    let colors: AxesColors = AxesColors(x: .red, y: .green, z: .blue)
    let transform: SCNMatrix4 = SCNMatrix4Identity
    
    private init(axisSize: AxisSize) {
        self.axisSize = axisSize
        self.geometry = SCNBox(width: CGFloat(axisSize.width),
                               height: CGFloat(axisSize.length),
                               length: CGFloat(axisSize.depth),
                               chamferRadius: 0.0)
    }
    
    static func make(for node: SCNNode, customAxisLength: SCNFloat? = nil) -> AxesSettings {
        let length = customAxisLength ?? node.lengthOfTheGreatestSideOfNodeBox
        let nodeSize = node.lengthOfTheGreatestSideOfNodeBox
        return LocalAxesSettings(axisSize: makeAxisSize(from: nodeSize, length: length))
    }
}


//MARK: PivotAxesSettings
struct PivotAxesSettings: AxesSettings, AuxiliaryAxesSettings {
    static let defaultAxesSizeValue: SCNFloat = 0.07
    static let sizeValueInFractionsOfNodeSize: SCNFloat = 0.005
    static let lengthExtraFactor: SCNFloat = 1.5
    
    let axisSize: AxisSize
    let geometry: SCNGeometry
    let transform: SCNMatrix4
    let name: String = CoordinateSystem.pivot
    let colors: AxesColors = AxesColors(x: .magenta, y: .yellow, z: .cyan)
    
    private init(axisSize: AxisSize, pivotTransform: SCNMatrix4) {
        self.axisSize = axisSize
        self.geometry = SCNBox(width: CGFloat(axisSize.width),
                               height: CGFloat(axisSize.length),
                               length: CGFloat(axisSize.depth),
                               chamferRadius: 0.0)
        self.transform = pivotTransform
    }
    
    static func make(for node: SCNNode, overlappingNode: SCNNode? = nil) -> AxesSettings {
        let length = overlappingNode?.lengthOfTheGreatestSideOfNodeBox ?? (node.lengthOfTheGreatestSideOfNodeBox * lengthExtraFactor)
        let nodeSize = overlappingNode?.lengthOfTheGreatestSideOfNodeBox ?? node.lengthOfTheGreatestSideOfNodeBox
        return PivotAxesSettings(axisSize: makeAxisSize(from: nodeSize, length: length),
                                 pivotTransform: node.pivot)
    }
}
