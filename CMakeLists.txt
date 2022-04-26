cmake_minimum_required(VERSION 2.8.11)

if(NOT THIRDPARTY_ROOT AND NOT DEFINED ENV{THIRDPARTY_ROOT})
    message(
            FATAL_ERROR
                "Unable to set THIRDPARTY_ROOT. Please set THIRDPARTY_ROOT enviroment"
        )
else()
    if(NOT THIRDPARTY_ROOT)
        set(THIRDPARTY_ROOT $ENV{THIRDPARTY_ROOT})
    endif()
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${THIRDPARTY_ROOT}/cmake")
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${THIRDPARTY_ROOT}/cmake/Modules")
endif()


if(NOT BUILD_PLATFORM AND NOT DEFINED ENV{BUILD_PLATFORM})
    message(
            FATAL_ERROR
            "Unable to set BUILD_PLATFORM. Please set BUILD_PLATFORM environment"
        )
else()
    if(NOT BUILD_PLATFORM)
        set(BUILD_PLATFORM $ENV{BUILD_PLATFORM})
    endif()
endif()

set(CMAKE_INSTALL_PREFIX ${THIRDPARTY_ROOT}/install)
set(THIRDPARTY_INSTALL_PATH ${THIRDPARTY_ROOT}/install)

include(ExternalProject)
include(ProjectPatch)
include(ThirdpartyCache)

find_program(CHRPATH_EXECUTABLE chrpath)

if(NOT CHRPATH_EXECUTABLE)
    message(
        FATAL_ERROR
        "chrpath executable not found. Please install chrpath, run \"sudo apt-get install chrpath\""
        )
endif()

if(CMAKE_VERBOSE_MAKEFILE)
    set(VERBOSE_CMAKE "-DCMAKE_VERBOSE_MAKEFILE=ON")
    set(VERBOSE_MAKEFILE "VERBOSE=1")
    set(VERBOSE_B2 "-d+2")
endif()

add_subdirectory(packages/zlib)
message(STATUS "ZLIB_TARGET=${ZLIB_TARGET}")
add_subdirectory(packages/jpeg)
message(STATUS "JPEG_TARGET=${JPEG_TARGET}")
add_subdirectory(packages/opendds)
message(STATUS "OPENDDS_TARGET=${OPENDDS_TARGET}")
add_subdirectory(packages/opencv)
message(STATUS "OPENDDS_TARGET=${OPENCV_TARGET}")

if(BUILD_PLATFORM MATCHES "ubuntu_x86-64")
    add_custom_target(
        ALL
        DEPENDS ${ZLIB_TARGET}
        DEPENDS ${JPEG_TARGET}
        DEPENDS ${OPENDDS_TARGET}
        DEPENDS ${OPENCV_TARGET}
        )
endif()

