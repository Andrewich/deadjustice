project(
    bsp
    VERSION 0.65
    DESCRIPTION
        "BSP tree classes"
    LANGUAGES CXX
)

add_library(bsp STATIC)

include_directories(internal)

target_sources(bsp 
    PRIVATE
        BSPBalanceSplitSelector.cpp
        BSPBoxSplitSelector.cpp
        BSPCollisionUtil.cpp
        BSPFile.cpp
        BSPNode.cpp
        BSPPolygon.cpp
        BSPScoreFunc.cpp
        BSPSplitSelector.cpp
        BSPStorage.cpp
        BSPTree.cpp
        BSPTreeBuilder.cpp)
