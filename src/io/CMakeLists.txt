project(
    io
    VERSION 0.65
    DESCRIPTION
        "Input/output streaming library. Designed to match closely java.io.*"
    LANGUAGES CXX
)

add_library(io STATIC)

include_directories(internal)

target_sources(io 
    PRIVATE
        internal/StdioEx.cpp
        ByteArrayInputStream.cpp
        ByteArrayOutputStream.cpp        
        ChunkInputStream.cpp
        ChunkOutputStream.cpp
        CommandReader.cpp
        DataInputStream.cpp
        DataOutputStream.cpp
        DirectoryInputStreamArchive.cpp
        File.cpp
        FileInputStream.cpp
        FileOutputStream.cpp
        FilterInputStream.cpp
        FilterOutputStream.cpp
        InputStream.cpp
        InputStreamReader.cpp
        OutputStream.cpp
        OutputStreamWriter.cpp
        Reader.cpp
        Writer.cpp)