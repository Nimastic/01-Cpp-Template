cmake_minimum_required(VERSION 3.21) # uses CMake version 3.21
project(MyProject VERSION 1.0.0 LANGUAGES CXX) # MyProject name, V1, Enable C++ compiler (C CXX for both)

set(CMAKE_CXX_STANDARD 20) #Tells CMake to use C++20
set(CMAKE_CXX_STANDARD_REQUIRED ON) #Make ^ Mandatory, else fallback on available versions 
set(CMAKE_EXPORT_COMPILE_COMMANDS ON) #Generates compile_commands.json
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

# Include custom CMake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake") #Add path to CMake modules
include(CompilerWarnings) #Loads and executes cmake/CompilerWarnings.cmake

# Find packages listed by vcpkg
find_package(fmt CONFIG REQUIRED)
find_package(GTest CONFIG REQUIRED)

# Options
option(ENABLE_TESTING "Enable tests" ON) #Creates user configurable boolean option
option(ENABLE_SANITIZERS "Enable ASan/UBSan" OFF) #Checks for AS UB, but off as it slows down program

add_subdirectory(src) #tells CMake to process src/CMakeLists.txt

if(ENABLE_TESTING)
    enable_testing()
    add_subdirectory(tests)
endif()

if(ENABLE_SANITIZERS)
    add_compile_options(-fsanitize=address,undefined -fno-omit-frame-pointer)
    add_link_options(-fsanitize=address,undefined)
endif()