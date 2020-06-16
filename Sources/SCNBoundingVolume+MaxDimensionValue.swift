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
    public typealias SCNFloat = CGFloat
#else
	public typealias SCNFloat = Float
#endif

extension SCNBoundingVolume {
    private var height: SCNFloat {
        let (min, max) = self.boundingBox
        return max.y - min.y
    }
    
    private var width: SCNFloat {
        let (min, max) = self.boundingBox
        return max.x - min.x
    }
    
    private var length: SCNFloat {
        let (min, max) = self.boundingBox
        return max.z - min.z
    }
    
    var lengthOfTheGreatestSide: SCNFloat {
        return max(width, max(height, length))
    }
}
