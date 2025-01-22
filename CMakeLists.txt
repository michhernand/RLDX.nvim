cmake_minimum_required(VERSION 3.15)
project(rolodex LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 23)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(${CMAKE_BINARY_DIR}/build/Release/generators/conan_toolchain.cmake)

find_package(cli REQUIRED)
find_package(RocksDB REQUIRED)

add_executable(rolodex src/main.cpp src/crud.cpp)

target_include_directories(rolodex PRIVATE ${CMAKE_SOURCE_DIR}/include)

target_link_libraries(rolodex PRIVATE cli::cli RocksDB::rocksdb)

