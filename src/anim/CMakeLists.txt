project(
    anim
    VERSION 0.65
    DESCRIPTION
        "Low level animation classes"
    LANGUAGES CXX
)

add_library(anim STATIC)

include_directories(internal)

target_sources(anim 
    PRIVATE
        internal/Quat.cpp
        Animatable.cpp
        Control.cpp
        Interpolator.cpp
        QuaternionInterpolator.cpp
        VectorInterpolator.cpp)
