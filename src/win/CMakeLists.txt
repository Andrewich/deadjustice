project(
    win
    VERSION 0.65
    DESCRIPTION
        "Simple Win32 wrapper library"
    LANGUAGES CXX
)

add_library(win STATIC)

include_directories(internal)

target_sources(win 
    PRIVATE
        internal/StdAfx.cpp
        FrameWindow.cpp
        Window.cpp)