project(
    deadjustice
    VERSION 0.65
    DESCRIPTION
        "Prototype of 3rd person action/adventure game"
    LANGUAGES CXX
)

add_executable(deadjustice WIN32)

target_sources(deadjustice 
    PRIVATE 
    BellCurve.cpp
    BlendData.cpp
    Blender.cpp
    BoneCollisionBox.cpp
    build.cpp
    CollisionInfo.cpp
    ComputerControl.cpp
    ControlBase.cpp
    ControlSector.cpp
    ControlSet.cpp
    Game.cpp
    GameAction.cpp
    GameBoxTrigger.cpp
    GameBSPTree.cpp
    GameCamera.cpp
    GameCell.cpp
    GameCharacter.cpp
    GameController.cpp
    GameCutScene.cpp
    GameDynamicObject.cpp
    GameFlareSet.cpp
    GameLevel.cpp
    GameMusic.cpp
    GameNoise.cpp
    GameNoiseManager.cpp
    GameObject.cpp
    GameObjectList.cpp
    GameObjectListItem.cpp
    GamePath.cpp
    GamePointObject.cpp
    GamePortal.cpp
    GameProjectile.cpp
    GameScriptable.cpp
    GameSphereObject.cpp
    GameSurface.cpp
    GameWeapon.cpp
    GameWindow.cpp
    main.cpp
    MorphAnimation.cpp
    MovementAnimation.cpp
    OverlayBitmap.cpp
    OverlayDisplay.cpp
    OverlayFont.cpp
    PhysicalCombatCombo.cpp
    PhysicalCombatMove.cpp
    printMemoryState.cpp
    ProjectileManager.cpp
    TextureAnimation.cpp
    TextureSequence.cpp
    Timer.cpp
    UserControl.cpp
    Script1.rc)

#target_link_libraries(deadjustice lang win util io math anim dev libjpeg pix gd_dx9 sg sgu)
