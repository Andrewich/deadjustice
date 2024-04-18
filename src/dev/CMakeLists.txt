project(
    dev
    VERSION 0.65
    DESCRIPTION
        "Development helper classes for profiling"
    LANGUAGES CXX
)

add_library(dev STATIC)

include_directories(internal)

target_sources(dev 
    PRIVATE
        Profile.cpp
        TimeStamp.cpp)