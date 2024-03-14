cmake_minimum_required(VERSION 3.25)

project(
    deadjustice
    VERSION 0.65
    DESCRIPTION
        "3D Action/Adventure Game Prototype created by Cat Mother."
    HOMEPAGE_URL https://github.com/Andrewich/deadjustice.git
    LANGUAGES CXX
)

include_directories(src)

add_subdirectory(src/lang)

add_subdirectory(examples)

add_subdirectory(tests)
enable_testing()