if(TARGET ANN::library)
    return()
endif()

add_library(ANN::library SHARED IMPORTED)

# INTERFACE_INCLUDE_DIRECTORIES for ANN have been remove because headers not included in package

if(MSVC)
    set_target_properties(
        ANN::library
        PROPERTIES
            IMPORTED_LOCATION
                "${CMAKE_CURRENT_LIST_DIR}/bin/ANN.dll"
            IMPORTED_LOCATION_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/bin/ANNd.dll"
            IMPORTED_IMPLIB
                "${CMAKE_CURRENT_LIST_DIR}/bin/ANN.lib"
            IMPORTED_IMPLIB_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/bin/ANNd.lib"
            INTERFACE_INCLUDE_DIRECTORIES
                "${CMAKE_CURRENT_LIST_DIR}/include/"
    )
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set_target_properties(
        ANN::library
        PROPERTIES
            IMPORTED_LOCATION
                "${CMAKE_CURRENT_LIST_DIR}/bin/ANN.so"
            IMPORTED_LOCATION_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/bin/ANNd.so"
            INTERFACE_INCLUDE_DIRECTORIES
                "${CMAKE_CURRENT_LIST_DIR}/include/"
        )
endif()

set(
    COMPONENT_NAMES

    CNPM_RUNTIME_ANN_library
)

foreach(COMPONENT_NAME ${COMPONENT_NAMES})
    install(
        FILES
            $<TARGET_FILE:ANN::library>
        DESTINATION
            .
        COMPONENT
            ${COMPONENT_NAME}
        EXCLUDE_FROM_ALL
    )
endforeach()