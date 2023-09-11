function(
    GET_ALL_IMPORTED_DEPENDENCIES
    TARGET_NAME
    OUTPUT_VARIABLE_NAME
)
    GET_ALL_IMPORTED_DEPENDENCIES_HELPER(
        ${TARGET_NAME}
        "OUTPUT_LIST"
        "USED_TARGETS"
    )

    set(
        ${OUTPUT_VARIABLE_NAME}
        ${OUTPUT_LIST}
        PARENT_SCOPE
    )
endfunction()

function(
    GET_ALL_IMPORTED_DEPENDENCIES_HELPER
    TARGET_NAME
    OUTPUT_VARIABLE_NAME
    USED_TARGETS_NAME
)
    if (NOT TARGET ${TARGET_NAME})
        message(FATAL_ERROR "not a target")
    endif()

    # list of all processed targets.
    # to avoid double target processing
    set(
        USED_TARGETS
        "${${USED_TARGETS_NAME}}"
    )

    # the result list - only shared imported targets
    set(
        OUTPUT_LIST
        "${${OUTPUT_VARIABLE_NAME}}"
    )

    # check that target wasn't already processed
    list(
        FIND
        USED_TARGETS
        ${TARGET_NAME}
        LIST_INDEX
    )

    if (LIST_INDEX GREATER -1)
        return()
    endif()

    list(
        APPEND
        USED_TARGETS
        ${TARGET_NAME}
    )

    set(
        TARGET_LINK_LIBRARIES
        ""
    )

    get_target_property(
        TARGET_NAME_TYPE
        ${TARGET_NAME}
        TYPE
    )

    if(
        TARGET_NAME_TYPE STREQUAL "STATIC_LIBRARY"
        OR TARGET_NAME_TYPE STREQUAL "MODULE_LIBRARY"
        OR TARGET_NAME_TYPE STREQUAL "SHARED_LIBRARY"
        OR TARGET_NAME_TYPE STREQUAL "OBJECT_LIBRARY"
        OR TARGET_NAME_TYPE STREQUAL "EXECUTABLE"
    )
        get_target_property(
            TARGET_LINK_LIBRARIES
            ${TARGET_NAME}
            LINK_LIBRARIES
        )
    elseif(TARGET_NAME_TYPE STREQUAL "INTERFACE_LIBRARY")
        get_target_property(
            TARGET_LINK_LIBRARIES
            ${TARGET_NAME}
            INTERFACE_LINK_LIBRARIES
        )
    endif()

    foreach(LINKED_ENTITY IN LISTS TARGET_LINK_LIBRARIES)
        if(NOT TARGET ${LINKED_ENTITY})
            continue()
        endif()

        get_target_property(
            LINKED_ENTITY_IMPORTED
            ${LINKED_ENTITY}
            IMPORTED
        )
        get_target_property(
            LINKED_ENTITY_TYPE
            ${LINKED_ENTITY}
            TYPE
        )

        if (LINKED_ENTITY_IMPORTED)
            if (LINKED_ENTITY_TYPE STREQUAL "SHARED_LIBRARY")
                # maybe this target already in the result list?
                list(
                    FIND
                    OUTPUT_LIST
                    ${LINKED_ENTITY}
                    LIST_INDEX
                )
                if (LIST_INDEX GREATER -1)
                    continue()
                endif()

                list(
                    APPEND
                    OUTPUT_LIST
                    ${LINKED_ENTITY}
                )
            endif()
        endif()

        GET_ALL_IMPORTED_DEPENDENCIES_HELPER(
            ${LINKED_ENTITY}
            "OUTPUT_LIST"
            "USED_TARGETS"
        )
    endforeach()

    set(
        ${USED_TARGETS_NAME}
        ${USED_TARGETS}
        PARENT_SCOPE
    )

    set(
        ${OUTPUT_VARIABLE_NAME}
        ${OUTPUT_LIST}
        PARENT_SCOPE
    )
endfunction()

