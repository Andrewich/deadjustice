project(
    win
    VERSION 0.65
    DESCRIPTION
        "Simple Win32 wrapper library"
    LANGUAGES CXX
)

find_package(SDL2 REQUIRED CONFIG)

add_library(win STATIC)

include_directories(internal)

target_sources(win 
    PRIVATE
        internal/config.h
        internal/StdAfx.h
        FrameWindow.h
        Window.h
        internal/StdAfx.cpp
        FrameWindow.cpp
        Window.cpp)

target_include_directories(win PRIVATE ${SDL2_INCLUDE_DIRS})
