project(
    tester
    VERSION 0.65
    DESCRIPTION
        "Simple testing framework"
    LANGUAGES CXX
)

add_executable(tester)

target_sources(tester PRIVATE main.cpp)
target_include_directories(tester PRIVATE ${CMAKE_ROOT}/src)

target_compile_features(tester PUBLIC cxx_std_17)
