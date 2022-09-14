import RedECS

public struct MainReducer: Reducer {
    public typealias State = GameState
    public typealias Action = GameAction
    public typealias Environment = RenderingEnvironment
    
    public func reduce(state: inout GameState, delta: Double, environment: Environment) -> GameEffect<GameState, GameAction> {
        .none
    }
    
    public func reduce(state: inout GameState, action: GameAction, environment: Environment) -> GameEffect<GameState, GameAction> {
        switch action {
        case .didLaunch:
            print("game did launch")
            return .game(.resourceLoading(.load(groupName: "initial", resources: [
                .init(name: "pt-mono.fnt", type: .bitmapFont)
            ])))
        case .setUpStage:
            return .many([
                .newEntity(
                    "label",
                    with: \.sprite,
                    \.transform,
                    \.operation,
                    \.keyboardInput
                ) { sprite, transform, operation, keyboardInput in
                    transform.position = .init(x: 200, y: 200)
                    sprite.type = .label(font: "PT-Mono", text: "Hello World")
                    operation.newOperation(
                        .rotate(.by(-30), duration: 0.5)
                        .repeat(.forever)
                    )
                    keyboardInput.keyMap = [
                        .init(keySet: [.upKey, .w], action: .up),
                        .init(keySet: [.downKey, .s], action: .down),
                        .init(keySet: [.leftKey, .a], action: .left),
                        .init(keySet: [.rightKey, .d], action: .right),
                    ]
                },
                .newEntity(
                    "camera",
                    with: \.camera,
                    \.transform
                ) { camera, transform in
                    transform.position = .init(x: 200, y: 200)
                }
            ])
        case .resourceLoading(let resourceLoadingAction):
            switch resourceLoadingAction {
            case .loadComplete(let groupName):
                print("game resource loading completed", resourceLoadingAction)
                if groupName == "initial" {
                    return .game(.setUpStage)
                }
                break
            default:
                break
            }
        case .up:
            state.modify(\.transform, ofEntity: "label") { transform in
                transform.position.y += 2
            }
        case .down:
            state.modify(\.transform, ofEntity: "label") { transform in
                transform.position.y -= 2
            }
        case .left:
            state.modify(\.transform, ofEntity: "label") { transform in
                transform.position.x -= 2
            }
        case .right:
            state.modify(\.transform, ofEntity: "label") { transform in
                transform.position.x += 2
            }
        default:
            break
        }
        return .none
    }
}
