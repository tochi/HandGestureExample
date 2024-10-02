//
//  ImmersiveView.swift
//  HandGestureExample
//
//  Created by Tomoyuki Tochihira on 2024/10/01.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
  @Environment(AppModel.self) var appModel
  @ObservedObject var gestureModel: HandGestureModel
  
  var body: some View {
    RealityView { content in
    } update: { _ in
      print("Left Hand: \(String(describing: gestureModel.leftHandAnchorOriginFromAnchorTransfor()?.columns.3.xyz))")
      print("Right Hand: \(String(describing: gestureModel.rightHandAnchorOriginFromAnchorTransfor()?.columns.3.xyz))")
    }
    .task {
      await gestureModel.start()
    }
    .task {
      await gestureModel.publishHandTrackingUpdates()
    }
    .task {
      await gestureModel.monitorSessionEvents()
    }
  }
}

#Preview(immersionStyle: .full) {
  ImmersiveView(gestureModel: HeartGestureModelContainer.handGestureModel)
    .environment(AppModel())
}
