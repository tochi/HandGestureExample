/*
 See the LICENSE.txt file for this sample’s licensing information.
 
 Abstract:
 Hand tracking updates.
 */

import ARKit
import SwiftUI

// https://zenn.dev/koichi_51/articles/8d768ea8b6907d
/// A model that contains up-to-date hand coordinate information.
@MainActor
class HandGestureModel: ObservableObject, @unchecked Sendable {
  let session = ARKitSession()
  var handTracking = HandTrackingProvider()
  @Published var latestHandTracking: HandsUpdates = .init(left: nil, right: nil)
  
  struct HandsUpdates {
    var left: HandAnchor?
    var right: HandAnchor?
  }
  
  func start() async {
    do {
      if HandTrackingProvider.isSupported {
        print("ARKitSession starting.")
        try await session.run([handTracking])
      }
    } catch {
      print("ARKitSession error:", error)
    }
  }
  
  func publishHandTrackingUpdates() async {
    for await update in handTracking.anchorUpdates {
      switch update.event {
      case .updated:
        let anchor = update.anchor
        
        // Publish updates only if the hand and the relevant joints are tracked.
        guard anchor.isTracked else { continue }
        
        // Update left hand info.
        if anchor.chirality == .left {
          latestHandTracking.left = anchor
        } else if anchor.chirality == .right { // Update right hand info.
          latestHandTracking.right = anchor
        }
      default:
        break
      }
    }
  }
  
  func monitorSessionEvents() async {
    for await event in session.events {
      switch event {
      case .authorizationChanged(let type, let status):
        if type == .handTracking && status != .allowed {
          // Stop the game, ask the user to grant hand tracking authorization again in Settings.
        }
      default:
        print("Session event \(event)")
      }
    }
  }
  
  func rightHandAnchorOriginFromAnchorTransform() -> simd_float4x4? {
    guard let rightHandAnchor = latestHandTracking.right, rightHandAnchor.isTracked else { return nil }
    return rightHandAnchor.originFromAnchorTransform
  }
  
  func rightHandIndexFingerTipAnchorFromJointTransform() -> simd_float4x4? {
    guard let rightHandIndexFingerTip = latestHandTracking.right?.handSkeleton?.joint(.indexFingerTip),
          rightHandIndexFingerTip.isTracked  else { return nil }
    return rightHandIndexFingerTip.anchorFromJointTransform
  }
  
  func originFromRightHandIndexFingerTipTransform() -> simd_float4x4? {
    guard let rightHandAnchorOriginFromAnchorTransfor = rightHandAnchorOriginFromAnchorTransform(),
          let rightHandIndexFingerTipAnchorFromJointTransform = rightHandIndexFingerTipAnchorFromJointTransform() else { return nil }
    return matrix_multiply(rightHandAnchorOriginFromAnchorTransfor, rightHandIndexFingerTipAnchorFromJointTransform)
  }

  func rightHandMiddleFingerTipAnchorFromJointTransform() -> simd_float4x4? {
    guard let rightHandMiddleFingerTip = latestHandTracking.right?.handSkeleton?.joint(.middleFingerTip),
          rightHandMiddleFingerTip.isTracked  else { return nil }
    return rightHandMiddleFingerTip.anchorFromJointTransform
  }
  
  func originFromRightHandMiddleFingerTipTransform() -> simd_float4x4? {
    guard let rightHandAnchorOriginFromAnchorTransfor = rightHandAnchorOriginFromAnchorTransform(),
          let rightHandMiddleFingerTipAnchorFromJointTransform = rightHandMiddleFingerTipAnchorFromJointTransform() else { return nil }
    return matrix_multiply(rightHandAnchorOriginFromAnchorTransfor, rightHandMiddleFingerTipAnchorFromJointTransform)
  }
  
  func rightHandFingerCenterTransform() -> simd_float4x4? {
    guard let originFromRightHandIndexFingerTipTransform = originFromRightHandIndexFingerTipTransform(),
          let originFromRightHandMiddleFingerTipTransform = originFromRightHandMiddleFingerTipTransform() else { return nil }
    let position1 = originFromRightHandIndexFingerTipTransform.columns.3.xyz
    let position2 = originFromRightHandMiddleFingerTipTransform.columns.3.xyz
    
    let centerPosition = (position1 + position2) * 0.5
    
    var centerMatrix = matrix_identity_float4x4
    centerMatrix.columns.3 = simd_float4(centerPosition, 1)
    
    return centerMatrix
  }

  func leftHandAnchorOriginFromAnchorTransform() -> simd_float4x4? {
    guard let leftHandAnchor = latestHandTracking.left, leftHandAnchor.isTracked else { return nil }
    return leftHandAnchor.originFromAnchorTransform
  }

  func leftHandIndexFingerTipAnchorFromJointTransform() -> simd_float4x4? {
    guard let leftHandIndexFingerTip = latestHandTracking.left?.handSkeleton?.joint(.indexFingerTip),
          leftHandIndexFingerTip.isTracked  else { return nil }
    return leftHandIndexFingerTip.anchorFromJointTransform
  }
  
  func originFromLeftHandIndexFingerTipTransform() -> simd_float4x4? {
    guard let leftHandAnchorOriginFromAnchorTransfor = leftHandAnchorOriginFromAnchorTransform(),
          let leftHandIndexFingerTipAnchorFromJointTransform = leftHandIndexFingerTipAnchorFromJointTransform() else { return nil }
    return matrix_multiply(leftHandAnchorOriginFromAnchorTransfor, leftHandIndexFingerTipAnchorFromJointTransform)
  }
  
  func leftHandMiddleFingerTipAnchorFromJointTransform() -> simd_float4x4? {
    guard let leftHandMiddleFingerTip = latestHandTracking.left?.handSkeleton?.joint(.middleFingerTip),
          leftHandMiddleFingerTip.isTracked  else { return nil }
    return leftHandMiddleFingerTip.anchorFromJointTransform
  }
  
  func originFromLeftHandMiddleFingerTipTransform() -> simd_float4x4? {
    guard let leftHandAnchorOriginFromAnchorTransfor = leftHandAnchorOriginFromAnchorTransform(),
          let leftHandMiddleFingerTipAnchorFromJointTransform = leftHandMiddleFingerTipAnchorFromJointTransform() else { return nil }
    return matrix_multiply(leftHandAnchorOriginFromAnchorTransfor, leftHandMiddleFingerTipAnchorFromJointTransform)
  }
  
  func leftHandFingerCenterTransform() -> simd_float4x4? {
    guard let originFromLeftHandIndexFingerTipTransform = originFromLeftHandIndexFingerTipTransform(),
          let originFromLeftHandMiddleFingerTipTransform = originFromLeftHandMiddleFingerTipTransform() else { return nil }
    let position1 = originFromLeftHandIndexFingerTipTransform.columns.3.xyz
    let position2 = originFromLeftHandMiddleFingerTipTransform.columns.3.xyz
    
    let centerPosition = (position1 + position2) * 0.5
    
    var centerMatrix = matrix_identity_float4x4
    centerMatrix.columns.3 = simd_float4(centerPosition, 1)
    
    return centerMatrix
  }
}
