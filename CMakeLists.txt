cmake_minimum_required(VERSION 3.10)

project(ANN)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src include)

file(GLOB_RECURSE srcs_cpp src/*.cpp)
file(GLOB_RECURSE hdrs src/*.h*)

add_definitions(-DDLL_EXPORTS)
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_SKIP_BUILD_RPATH FALSE)
    set(CMAKE_SKIP_INSTALL_RPATH FALSE)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
    set(CMAKE_INSTALL_RPATH "\$ORIGIN/")
endif()

set(CMAKE_DEBUG_POSTFIX d)


add_library(${PROJECT_NAME} SHARED ${srcs_cpp}  ${hdrs})
# set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")

# ANN generates many warnings related to the "register" keyword
# We decided to supress it and make more visible warnings from gridding library
if(MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /wd5033)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(${PROJECT_NAME} PRIVATE -Wno-register)
endif()

install (TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION bin
    ARCHIVE DESTINATION bin
    PUBLIC_HEADER DESTINATION include
)

if("${CMAKE_SYSTEM_NAME}" MATCHES "Windows")
    install(FILES $<TARGET_PDB_FILE:${PROJECT_NAME}> DESTINATION bin OPTIONAL)
endif()
