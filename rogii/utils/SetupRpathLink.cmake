include(
    "${CMAKE_CURRENT_LIST_DIR}/GetAllImportedDependencies.cmake"
)

function(
    SETUP_RPATH_LINK
    TARGET_NAME
)
    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU"
        OR CMAKE_C_COMPILER_ID STREQUAL "GNU"
    )
        SETUP_RPATH_LINK_IMPL(
            "${TARGET_NAME}"
        )
    endif()
endfunction()

function(
    SETUP_RPATH_LINK_IMPL
    TARGET_NAME
)
    get_target_property(
        RPATH_LINK_FLAGS
        ${TARGET_NAME}
        LINK_FLAGS
    )

    if (RPATH_LINK_FLAGS STREQUAL "RPATH_LINK_FLAGS-NOTFOUND")
        set(
            RPATH_LINK_FLAGS
            ""
        )
    endif()

    set(
        RPATH_LINK_FLAGS
        "${RPATH_LINK_FLAGS} -Wl,--enable-new-dtags"
    )

    GET_ALL_IMPORTED_DEPENDENCIES(
        ${TARGET_NAME}
        "OUTPUT_LIST"
    )

    foreach (IMPORTED_TARGET IN LISTS OUTPUT_LIST)
        get_target_property(
            LINKED_TARGET_PROPERTY
            ${IMPORTED_TARGET}
            LOCATION
        )

        if (LINKED_TARGET_PROPERTY STREQUAL "NOTFOUND")
            continue()
        endif()

        string(
            FIND
            "${LINKED_TARGET_PROPERTY}"
            "/"
            SLASH_INDEX
            REVERSE
        )

        string(
            SUBSTRING
            "${LINKED_TARGET_PROPERTY}"
            0
            ${SLASH_INDEX}
            IMPORTED_TARGET_DIRECTORY
        )

        set(
            RPATH_LINK_FLAGS
            "${RPATH_LINK_FLAGS} -Wl,-rpath-link,${IMPORTED_TARGET_DIRECTORY}/"
        )
    endforeach()

    set_target_properties(
        ${TARGET_NAME}
        PROPERTIES
            LINK_FLAGS
                "${RPATH_LINK_FLAGS}"
    )
endfunction()

