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
    )
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set_target_properties(
        ANN::library
        PROPERTIES
            IMPORTED_LOCATION
                "${CMAKE_CURRENT_LIST_DIR}/bin/ANN.so"
            IMPORTED_LOCATION_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/bin/ANNd.so"
        )
endif()

set(
    COMPONENT_NAMES

    CNPM_RUNTIME_Gridding_ANN
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

include(
    "${CMAKE_CURRENT_LIST_DIR}/package_options.cmake"
)
