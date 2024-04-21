project(
    crypt
    VERSION 0.65
    DESCRIPTION
        ""
    LANGUAGES CXX
)

add_library(crypt STATIC)

include_directories(internal)

target_sources(crypt 
    PRIVATE
        CryptUtil.cpp
        DecryptDirectoryInputStreamArchive.cpp
        DecryptInputStream.cpp)
