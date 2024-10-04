//
//  ContentView.swift
//  HandGestureExample
//
//  Created by Tomoyuki Tochihira on 2024/10/01.
//

import SwiftUI
import RealityKit

struct ContentView: View {
  @ObservedObject var gestureModel: HandGestureModel
  
  var body: some View {
    VStack {
      Spacer()
      HStack() {
        handAnchorLogView(title: "Left", handAnchorOriginFromAnchorTransfor: gestureModel.leftHandAnchorOriginFromAnchorTransfor())
        Spacer()
        handAnchorLogView(title: "Right", handAnchorOriginFromAnchorTransfor: gestureModel.rightHandAnchorOriginFromAnchorTransfor())
      }
      .padding(EdgeInsets(top: 0, leading: 400, bottom: 0, trailing: 400))
      Spacer()
      ToggleImmersiveSpaceButton()
      Spacer()
    }
  }
  
  func handAnchorLogView(title: String, handAnchorOriginFromAnchorTransfor: simd_float4x4?) -> some View {
    VStack(alignment: .leading) {
      Text("\(title) Hand Anchor")
        .font(.title)
      if (handAnchorOriginFromAnchorTransfor != nil) {
        Text("x: \(String(describing: handAnchorOriginFromAnchorTransfor!.columns.3.x))")
        Text("y: \(String(describing: handAnchorOriginFromAnchorTransfor!.columns.3.y))")
        Text("z: \(String(describing: handAnchorOriginFromAnchorTransfor!.columns.3.z))")
      } else {
        Text("x:")
        Text("y:")
        Text("z:")
      }
    }

  }
}

#Preview(windowStyle: .automatic) {
  ContentView(gestureModel: HeartGestureModelContainer.handGestureModel)
    .environment(AppModel())
}
