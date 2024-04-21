project(
    fsm
    VERSION 0.65
    DESCRIPTION
        "Finite state machine library"
    LANGUAGES CXX
)

add_library(fsm STATIC)

target_sources(fsm 
    PRIVATE
        StateMachine.cpp)
