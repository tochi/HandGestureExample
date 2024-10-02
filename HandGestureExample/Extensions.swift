/*
 See the LICENSE.txt file for this sample’s licensing information.
 
 Abstract:
 Extensions and utilities.
 */

import SwiftUI
import RealityKit

extension SIMD4 {
  var xyz: SIMD3<Scalar> {
    self[SIMD3(0, 1, 2)]
  }
}

