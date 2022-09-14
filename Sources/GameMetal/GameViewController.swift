import GameShared
import SpriteKit
import RedECS
import RedECSBasicComponents
import RedECSAppleSupport
import Geometry

public class GameViewController: MetalViewController {
    var store: GameStore<AnyReducer<GameShared.GameState, GameShared.GameAction, MetalEnvironment>>!
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.resourceManager.resourceBundle = .module
        store = GameStore(
            state: .init(),
            environment: MetalEnvironment(
                metalRenderer: self.renderer,
                metalResourceManager: self.resourceManager
            ),
            reducer: gameReducer
                .pullback(toLocalEnvironment: { $0 as RenderingEnvironment })
                .eraseToAnyReducer(),
            registeredComponentTypes: [
                .init(keyPath: \.transform),
                .init(keyPath: \.sprite),
                .init(keyPath: \.keyboardInput),
                .init(keyPath: \.operation),
                .init(keyPath: \.camera),
            ]
        )
        
        store.sendAction(.didLaunch)
        
        renderer.deltaCallback = { [weak self] delta in
            self?.renderer.clearQueue()
            self?.store.sendDelta(delta)
        }
    }
}

#if os(OSX)
extension GameViewController {
    public override func keyDown(with event: NSEvent) {
        if let key = KeyboardInput(rawValue: event.keyCode) {
            store.sendAction(.keyboardInput(.keyDown(key)))
        } else {
            print("unmapped key down", event.keyCode)
        }
    }

    public override func keyUp(with event: NSEvent) {
        if let key = KeyboardInput(rawValue: event.keyCode) {
            store.sendAction(.keyboardInput(.keyUp(key)))
        } else {
            print("unmapped key up", event.keyCode)
        }
    }
}
#endif
