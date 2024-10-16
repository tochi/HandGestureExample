import ARKit
import SwiftUI

@MainActor
class HandGestureModel: ObservableObject, @unchecked Sendable {
  let session = ARKitSession()
  var handTracking = HandTrackingProvider()
  @Published var latestHandTracking: HandsUpdates = .init(left: nil, right: nil)
  var rightHandAnchorOriginFromAnchorTransform: simd_float4x4? {
    guard let rightHandAnchor = latestHandTracking.right, rightHandAnchor.isTracked else { return nil }
    return rightHandAnchor.originFromAnchorTransform
  }
  var rightHandIndexFingerTipAnchorFromJointTransform: simd_float4x4? {
    guard let rightHandIndexFingerTip = latestHandTracking.right?.handSkeleton?.joint(.indexFingerTip),
          rightHandIndexFingerTip.isTracked  else { return nil }
    return rightHandIndexFingerTip.anchorFromJointTransform
  }
  var originFromRightHandIndexFingerTipTransform: simd_float4x4? {
    guard let rightHandAnchorOriginFromAnchorTransfor = rightHandAnchorOriginFromAnchorTransform,
          let rightHandIndexFingerTipAnchorFromJointTransform = rightHandIndexFingerTipAnchorFromJointTransform else { return nil }
    return matrix_multiply(rightHandAnchorOriginFromAnchorTransfor, rightHandIndexFingerTipAnchorFromJointTransform)
  }

  var leftHandAnchorOriginFromAnchorTransform: simd_float4x4? {
    guard let leftHandAnchor = latestHandTracking.left, leftHandAnchor.isTracked else { return nil }
    return leftHandAnchor.originFromAnchorTransform
  }
  var leftHandIndexFingerTipAnchorFromJointTransform: simd_float4x4? {
    guard let leftHandIndexFingerTip = latestHandTracking.left?.handSkeleton?.joint(.indexFingerTip),
          leftHandIndexFingerTip.isTracked  else { return nil }
    return leftHandIndexFingerTip.anchorFromJointTransform
  }
  var originFromLeftHandIndexFingerTipTransform: simd_float4x4? {
    guard let leftHandAnchorOriginFromAnchorTransfor = leftHandAnchorOriginFromAnchorTransform,
          let leftHandIndexFingerTipAnchorFromJointTransform = leftHandIndexFingerTipAnchorFromJointTransform else { return nil }
    return matrix_multiply(leftHandAnchorOriginFromAnchorTransfor, leftHandIndexFingerTipAnchorFromJointTransform)
  }
  
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
        guard anchor.isTracked else { continue }
        
        if anchor.chirality == .left {
          latestHandTracking.left = anchor
        } else if anchor.chirality == .right {
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
}
