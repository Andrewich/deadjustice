cmake_minimum_required(VERSION 3.29)

project(
    deadjustice
    VERSION 0.65
    DESCRIPTION
        "3D Action/Adventure Game Prototype created by Cat Mother."
    HOMEPAGE_URL https://github.com/Andrewich/deadjustice.git
    LANGUAGES CXX
)

set(CMAKE_DEBUG_POSTFIX d)

include_directories(src src/config/msvc6)

add_subdirectory(src/mem)
add_subdirectory(src/lang)