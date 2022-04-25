macro(THIRDPARTY_CACHE_SEARCH PACKAGE_NAME)
    message(STATUS "THIRDPARTY_ROOT =  ${THIRDPARTY_ROOT}")
    message(STATUS "PACKAGE_NAME =  ${PACKAGE_NAME}")
    if(EXISTS ${THIRDPARTY_ROOT}/packages/${PACKAGE_NAME}.tar.bz2)
        set(${PACKAGE_NAME}_CACHE_FOUND TRUE)
        set(${PACKAGE_NAME}_CACHE_PATH ${THIRDPARTY_ROOT}/packages/${PACKAGE_NAME}.tar.bz2)
    else()
        set(${PACKAGE_NAME}_CACHE_FOUND FALSE)
        set(${PACKAGE_NAME}_CACHE_PATH)
    endif()
endmacro(THIRDPARTY_CACHE_SEARCH)

macro(THIRDPARTY_ADD_CACHE_TARGET PACKAGE_NAME)
    set(${PACKAGE_NAME}_EXTRACT_COMMAND tar xvf ${${PACKAGE}_CACHE_PATH})
    add_custom_target(
        ${TARGET_NAME}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${THIRDPARTY_ROOT}
        COMMAND cd ${THIRDPARTY_ROOT} && ${${PACKAGE_NAME}_EXTRACT_COMMAND}
        WORKING_DIRECTORY ${THIRDPARTY_ROOT}
        COMMENT "Extracting cached build result ${${PACKAGE_NAME}_CACHE_PATH} VERBATIM"
        )
    message("prepare build ${TARGET_NAME} ... ")
endmacro(THIRDPARTY_ADD_CACHE_TARGET)

