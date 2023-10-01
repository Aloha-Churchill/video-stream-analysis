cmake_minimum_required(VERSION 3.10)

# Set project name
project(video-stream-analysis)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)

# Set build type
set(CMAKE_BUILD_TYPE Debug)

# Set output directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Set include directories
include_directories(include)

# Set source files
file(GLOB SOURCES "src/*.cpp")

# Add executable
add_executable(video-stream-analysis ${SOURCES})