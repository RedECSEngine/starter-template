import Geometry
import RedECS
import RedECSBasicComponents

public struct GameState: RenderableGameState {
    public var entities: EntityRepository = .init()
    
    public var camera: [EntityId: CameraComponent] = [:]
    public var sprite: [EntityId: SpriteComponent] = [:]
    public var transform: [EntityId: TransformComponent] = [:]
    
    public var keyboardInput: [EntityId: KeyboardInputComponent<GameAction>] = [:]
    public var operation: [EntityId : OperationComponent<GameAction>] = [:]
    
    public static let size: Size = .init(width: 414, height: 414)
    
    public init() {}
}

public extension GameState {
    var keyboardInputContext: KeyboardInputReducerContext<GameAction> {
        get {
            KeyboardInputReducerContext(entities: entities, keyboardInput: keyboardInput)
        }
        set {
            self.keyboardInput = newValue.keyboardInput
        }
    }
}

public extension GameState {
    var operationContext: OperationComponentContext<GameAction> {
        get {
            OperationComponentContext(
                entities: entities,
                operation: operation,
                transform: transform,
                sprite: sprite
            )
        }
        set {
            self.operation = newValue.operation
            self.transform = newValue.transform
            self.sprite = newValue.sprite
        }
    }
}
