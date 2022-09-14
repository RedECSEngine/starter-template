# RedECS Starter Template

A starter template to clone and start your game from

## Instructions

This template is broken down into 3 modules:

1. `GameShared` which contains all the game logic
2. `GameMetal` which is an executable MacOS target. You can run this right from Xcode by selecting it as the scheme to run.
3. `GameWeb` which is a Web exectable that needs building and launching via [Carton](https://github.com/swiftwasm/carton)
    - Run on web for development with `$ carton dev --product GameWeb`
    - You can still build this target in xcode to check for compilation errors, but it executes from command line with Carton

You will probably put most of your work in `GameShared`. Start by adjusting the `MainReducer` to work in your own game logic.

## Notes

- Currently both executables need their own copies of resources. Ideally this would be fixed in future with some build tooling for the engine.
