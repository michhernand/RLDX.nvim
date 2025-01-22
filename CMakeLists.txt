cmake_minimum_required(VERSION 3.15)
project(rolodex LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 23)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_compile_definitions(
    SQLITE_ENABLE_FTS5
    SQLITE_ENABLE_RTREE
    SQLITE_ENABLE_JSON1
    SQLITE_ENABLE_COLUMN_METADATA
    SQLITE_THREADSAFE=1
)

# Create a static library for SQLite3
add_library(sqlite3_static STATIC
    src/sqlite3/sqlite3.c
)

# Set C compiler flags for SQLite3
target_compile_definitions(sqlite3_static PRIVATE
    SQLITE_ENABLE_FTS5
    SQLITE_ENABLE_RTREE
    SQLITE_ENABLE_JSON1
    SQLITE_ENABLE_COLUMN_METADATA
    SQLITE_THREADSAFE=1
)

add_executable(rolodex 
    src/main.cpp 
    src/crud.cpp
    src/errors.cpp
)

target_link_libraries(rolodex PRIVATE sqlite3_static)

target_include_directories(rolodex PRIVATE 
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/src/sqlite3
)

if(UNIX)
    target_link_libraries(rolodex PRIVATE pthread dl m)
endif()

