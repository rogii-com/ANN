cmake_minimum_required(VERSION 3.15)

project(ANN VERSION 1.1.2 LANGUAGES CXX)

file(GLOB_RECURSE srcs_cpp src/*.cpp)
file(GLOB_RECURSE hdrs src/*.h*)

add_library(${PROJECT_NAME} SHARED ${srcs_cpp} ${hdrs})

target_compile_definitions(${PROJECT_NAME} PRIVATE DLL_EXPORTS)

target_include_directories(${PROJECT_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

# ANN generates many warnings related to the "register" keyword.
# We suppress them to keep more relevant warnings visible.
if(MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /wd5033)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(${PROJECT_NAME} PRIVATE -Wno-register)
endif()

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_SKIP_BUILD_RPATH FALSE)
    set(CMAKE_SKIP_INSTALL_RPATH FALSE)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
    set(CMAKE_INSTALL_RPATH "$ORIGIN/")
endif()

set(CMAKE_DEBUG_POSTFIX d)

install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/
    DESTINATION include
    FILES_MATCHING PATTERN "*.h"
)
