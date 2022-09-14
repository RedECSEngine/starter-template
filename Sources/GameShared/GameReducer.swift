import Geometry
import RedECS
import RedECSBasicComponents

public let gameReducer: AnyReducer<GameState, GameAction, RenderingEnvironment> = zip(
    MainReducer(),
    
    RenderingReducer<GameState>(renderableComponentTypes: [
        .init(keyPath: \.sprite),
    ])
    .pullback(
        toLocalState: \.self,
        toLocalEnvironment: { $0 as RenderingEnvironment }
    ),
    ResourceLoadingReducer<GameState>()
        .pullback(
            toLocalState: \.self,
            toLocalAction: { globalAction in
                switch globalAction {
                case .resourceLoading(let action):
                    return action
                default:
                    return nil
                }
            },
            toGlobalAction: { .resourceLoading($0) },
            toLocalEnvironment: { $0 as RenderingEnvironment }
        ),
    zip(
        KeyboardInputReducer()
            .pullback(
                toLocalState: \.keyboardInputContext,
                toLocalAction: { globalAction in
                    switch globalAction {
                    case .keyboardInput(let keyAction):
                        return keyAction
                    default:
                        return nil
                    }
                },
                toGlobalAction: { .keyboardInput($0) }
            ),
        KeyboardKeyMapReducer()
            .pullback(
                toLocalState: \.keyboardInputContext
            ),
        OperationReducer()
            .pullback(toLocalState: \.operationContext)
    ).pullback(toLocalEnvironment: { _ in () })
).eraseToAnyReducer()
