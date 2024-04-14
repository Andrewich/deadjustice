project(
    math
    VERSION 0.65
    DESCRIPTION
        "Low-level math classes"
    LANGUAGES CXX
)

add_library(math STATIC)

include_directories(internal)

target_sources(math 
    PRIVATE
        BezierUtilVector3.cpp
        BSphere.cpp
        BSphereBuilder.cpp
        EigenUtil.cpp
        Intersection.cpp
        Matrix3x3.cpp
        Matrix4x4.cpp
        MatrixMxN.cpp
        Noise.cpp
        OBBox.cpp
        OBBoxBuilder.cpp
        Quaternion.cpp
        ShapeBuffer.cpp
        Vector3.cpp)
