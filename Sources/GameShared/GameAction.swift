import RedECS
import RedECSBasicComponents

public enum GameAction: Equatable, Codable {
    case resourceLoading(ResourceLoadingAction)
    case keyboardInput(KeyboardInputAction)
    
    case didLaunch
    case setUpStage
    
    case up
    case down
    case left
    case right
}
