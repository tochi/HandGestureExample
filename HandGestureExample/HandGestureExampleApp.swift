//
//  HandGestureExampleApp.swift
//  HandGestureExample
//
//  Created by Tomoyuki Tochihira on 2024/10/01.
//

import SwiftUI

@main
struct HandGestureExampleApp: App {
  
  @State private var appModel = AppModel()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(appModel)
    }
    
    ImmersiveSpace(id: appModel.immersiveSpaceID) {
      ImmersiveView()
        .environment(appModel)
        .onAppear {
          appModel.immersiveSpaceState = .open
        }
        .onDisappear {
          appModel.immersiveSpaceState = .closed
        }
    }
    .immersionStyle(selection: .constant(.mixed), in: .mixed)
  }
}
