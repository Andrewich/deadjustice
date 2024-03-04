project(tests LANGUAGES CXX)

find_package(Catch2 CONFIG REQUIRED)
include(CTest)
include(Catch)

add_executable(tests)

target_sources(tests PRIVATE    
    lang.cpp)

target_link_libraries(tests PRIVATE Catch2::Catch2WithMain lang)
target_include_directories(tests PRIVATE "${Catch2_INCLUDE_DIR}")


catch_discover_tests(tests)