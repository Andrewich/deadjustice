project(
    ps
    VERSION 0.65
    DESCRIPTION
        "Particle system library"
    LANGUAGES CXX
)

add_library(ps STATIC)

include_directories(internal)

target_sources(ps 
    PRIVATE
        Box.cpp
        Flow.cpp
        Gravity.cpp
        HalfSphere.cpp
        ParticleSystem.cpp
        ParticleSystemManager.cpp
        PathParticleSystem.cpp
        Sphere.cpp
        SpriteParticleSystem.cpp)
