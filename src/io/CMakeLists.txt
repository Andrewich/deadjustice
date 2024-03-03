project(
    io
    VERSION 0.65
    DESCRIPTION
        "Input/output streaming library. Designed to match closely java.io.*"
    LANGUAGES CXX
)

add_library(io STATIC)

target_sources(io PRIVATE Temp.cpp)

target_compile_features(io PUBLIC cxx_std_17)