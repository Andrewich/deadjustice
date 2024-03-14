project(examples LANGUAGES CXX)

add_executable(messageBox)

target_sources(messageBox PRIVATE    
    utf8MessageBox.cpp)
target_link_libraries(messageBox PRIVATE lang)

target_compile_features(messageBox PUBLIC cxx_std_20)