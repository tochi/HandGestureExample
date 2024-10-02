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
  
  var body: some View {
    RealityView { content in
      
    }
  }
}

#Preview(immersionStyle: .full) {
  ImmersiveView()
    .environment(AppModel())
}
