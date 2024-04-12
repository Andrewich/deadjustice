project(
    zlib
    VERSION 1.1.3
    DESCRIPTION
        "A massively spiffy yet delicately unobtrusive compression library"
    HOMEPAGE_URL "https://github.com/madler/zlib/tree/v1.1.3"
    LANGUAGES C
)

add_library(zlib STATIC)

target_sources(zlib 
    PRIVATE
        adler32.c
        compress.c
        crc32.c
        deflate.c
        gzio.c
        infblock.c
        infcodes.c
        inffast.c
        inflate.c
        inftrees.c
        infutil.c
        trees.c
        uncompr.c
        zutil.c)