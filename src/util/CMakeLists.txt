project(
    util
    VERSION 0.65
    DESCRIPTION
        "Utility classes. Designed to match closely java.util.*"
    LANGUAGES CXX
)

add_library(util STATIC)

include_directories(internal)

target_sources(util 
    PRIVATE
        ExProperties.cpp
        Hashtable.cpp
        Properties.cpp
        Random.cpp)

add_subdirectory(zip)