project(
    music
    VERSION 0.65
    DESCRIPTION
        "Music (mp3) playback support"
    LANGUAGES CXX
)

add_library(music STATIC)

include_directories(internal)

target_sources(music 
    PRIVATE        
        MusicManager.cpp
        MusicPlayer.cpp)
