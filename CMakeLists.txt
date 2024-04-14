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

add_compile_definitions(_MBCS)

# External library
add_subdirectory(external/zlib)
add_subdirectory(external/libjpeg)

include_directories(src src/config/msvc6)

add_subdirectory(src/mem)
add_subdirectory(src/lang)
add_subdirectory(src/io)
add_subdirectory(src/win)
add_subdirectory(src/util)
add_subdirectory(src/math)
add_subdirectory(src/anim)
add_subdirectory(src/bsp)

# Examples
add_subdirectory(examples/win)