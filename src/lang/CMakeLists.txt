project(
    lang
    VERSION 0.65
    DESCRIPTION
        "Core classes, e.g. Unicode support and thread-safe reference counting. Designed to match closely java.lang.*"
    LANGUAGES CXX
)

add_library(lang STATIC)

target_sources(lang PRIVATE Character.cpp String.cpp)

target_compile_features(lang PUBLIC cxx_std_20)