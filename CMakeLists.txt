# Specify the minimum version of CMake required to build this project
cmake_minimum_required(VERSION 3.20)

# Get the directory name of the current source directory and store it in ProjectDirName
get_filename_component(ProjectDirName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

# Replace any spaces in the directory name with underscores and store it in ProjectName
string(REPLACE " " "_" ProjectName ${ProjectDirName})

project(${ProjectName})

message("\n\n***************** CMake INFO  *****************") 
message("PROJECT_NAME:          "  ${PROJECT_NAME})
message("PROJECT_SOURCE_DIR:    "  ${PROJECT_SOURCE_DIR})
message("PROJECT_BINARY_DIR:    "  ${PROJECT_BINARY_DIR})
message("***********************************************\n\n") 

# Set this to ON to export the commands in the compile_commands.json file
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# If the system is macOS (Darwin), set the architecture to arm64
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(CMAKE_OSX_ARCHITECTURES "arm64")
endif()

# Set the C++ standard to C++17
set(CMAKE_CXX_STANDARD 17)

# Find and include the redis++ package required for the project
find_package(redis++ REQUIRED)

# Collect all .cpp and .hpp files in the current directory and store them in SOURCES
file(GLOB SOURCES "*.cpp" "*.hpp")

add_executable(${PROJECT_NAME} ${SOURCES} )

target_link_libraries(${PROJECT_NAME} redis++::redis++_static)
target_link_libraries(${PROJECT_NAME})

