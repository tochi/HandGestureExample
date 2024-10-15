import SwiftUI

@main
struct HandGestureExampleApp: App {
  
  @State private var appModel = AppModel()
  
  var body: some Scene {
    WindowGroup {
      ContentView(gestureModel: HeartGestureModelContainer.handGestureModel)
        .environment(appModel)
    }
    
    ImmersiveSpace(id: appModel.immersiveSpaceID) {
      ImmersiveView(gestureModel: HeartGestureModelContainer.handGestureModel)
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


@MainActor
enum HeartGestureModelContainer {
    private(set) static var handGestureModel = HandGestureModel()
}
