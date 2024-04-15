project(
    sgu
    VERSION 0.65
    DESCRIPTION
        "Scene graph utility classes"
    LANGUAGES CXX
)

add_library(sgu STATIC)

include_directories(internal)

target_sources(sgu 
    PRIVATE
        internal/ChunkUtil.cpp
        CameraUtil.cpp
        ContextUtil.cpp
        LineListUtil.cpp
        LookAtControl.cpp
        MeshUtil.cpp
        ModelFile.cpp
        ModelFileCache.cpp
        NodeGroupSet.cpp
        NodeUtil.cpp
        SceneFile.cpp
        SceneManager.cpp
        ShadowUtil.cpp
        TextureUtil.cpp)
