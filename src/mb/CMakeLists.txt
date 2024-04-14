project(
    mb
    VERSION 0.65
    DESCRIPTION
        "Mesh builder library used for geometry processing"
    LANGUAGES CXX
)

add_library(mb STATIC)

include_directories(internal)

target_sources(mb 
    PRIVATE
        internal/LinkedItem.cpp
        internal/VMapImpl.cpp
        DiscontinuousVertexMap.cpp
        MeshBuilder.cpp
        MeshBuilderItem.cpp
        Polygon.cpp
        Vertex.cpp
        VertexMap.cpp)
