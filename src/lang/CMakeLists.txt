project(
    lang
    VERSION 0.65
    DESCRIPTION
        "Core classes, e.g. Unicode support and thread-safe reference counting. Designed to match closely java.lang.*"
    LANGUAGES CXX
)

add_library(lang STATIC)

add_compile_definitions(LANG_WIN32)

include_directories(internal)

target_sources(lang 
    PRIVATE 
        internal/Mutex.cpp 
        internal/Semaphore.cpp 
        internal/Thread_impl.cpp
        Character.cpp 
        Debug.cpp 
        Double.cpp 
        DynamicLinkLibrary.cpp 
        Float.cpp
        Format.cpp 
        Formattable.cpp 
        Integer.cpp 
        Long.cpp 
        Math.cpp 
        NumberReader.cpp
        Object.cpp 
        Short.cpp 
        String.cpp 
        System.cpp 
        Thread.cpp 
        Throwable.cpp
        UTFConverter.cpp)

if(MSVC)
    add_custom_command(TARGET lang POST_BUILD
        COMMAND LIB.exe "$<TARGET_FILE:lang>" "$<TARGET_IMPORT_FILE:mem>")

    #target_compile_options(lang PRIVATE "/wd4006")
endif()