project(
    snd
    VERSION 0.65
    DESCRIPTION
        "High level sound library with scene graph binding"
    LANGUAGES CXX
)

add_library(snd STATIC)

include_directories(internal)

target_sources(snd 
    PRIVATE
        Sound.cpp
        SoundFile.cpp
        SoundFormat.cpp
        SoundLoader.cpp
        SoundLock.cpp
        SoundManager.cpp)
