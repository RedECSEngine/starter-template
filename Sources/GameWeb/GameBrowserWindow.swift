import GameShared
import JavaScriptKit
import RedECS
import RedECSBasicComponents
import RedECSWebSupport
import Geometry

class GameBrowserWindow: WebBrowserWindow<GameShared.GameState, GameShared.GameAction, WebEnvironment> {
    public convenience init() {
        let state = GameShared.GameState()
        self.init(size: GameShared.GameState.size)
        setStoreAndBegin(
            GameStore(
                state: state,
                environment: WebEnvironment(
                    webRenderer: self.renderer,
                    webResourceManager: self.resourceManager
                ),
                reducer: gameReducer
                    .pullback(toLocalEnvironment: { $0 as RenderingEnvironment })
                    .eraseToAnyReducer(),
                registeredComponentTypes: [
                    .init(keyPath: \.transform),
                    .init(keyPath: \.sprite),
                    .init(keyPath: \.camera),
                    .init(keyPath: \.operation),
                    .init(keyPath: \.keyboardInput)
                ]
            )
        )
    }
    
    required init(size: Size) {
        super.init(size: size)
    }
    
    public override func startWebRenderer() {
        super.startWebRenderer()
        store.sendAction(.didLaunch)
    }

    public override func onKeyDown(_ key: KeyboardInput) {
        store.sendAction(.keyboardInput(.keyDown(key)))
    }
    
    public override func onKeyUp(_ key: KeyboardInput) {
        store.sendAction(.keyboardInput(.keyUp(key)))
    }
}
