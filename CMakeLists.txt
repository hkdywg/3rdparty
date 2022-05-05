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

if(BUILD_PLATFORM STREQUAL "v3h_aarch64")
    set(CMAKE_SYSTEM_NAME "Linux")
    set(CMAKE_SYSTEM_PROCESSOR "aarch64")
    set(AUTOTOOL_HOST "aarch64-poky-linux")
    set(CMAKE_CROSS_TOOLS_PATH /opt/poky/3.0.2/sysroots/x86_64-pokysdk-linux/usr/bin/aarch64-poky-linux)
    set(CMAKE_C_COMPILER ${CMAKE_CROSS_TOOLS_PATH}/aarch64-poky-linux-gcc)
    set(CMAKE_CXX_COMPILER ${CMAKE_CROSS_TOOLS_PATH}/aarch64-poky-linux-g++)
    set(CROSS_TOOLCHAIN_CONFIG_FILE ${CMAKE_CURRENT_LIST_DIR}/config/platform/Linux_Renesas_aarch64.cmake)
    message(STATUS "BUILD_PLATFORM=${BUILD_PLATFORM}")
endif()

set(CMAKE_INSTALL_PREFIX ${THIRDPARTY_ROOT}/build/install)
set(THIRDPARTY_INSTALL_PATH ${THIRDPARTY_ROOT}/build/install)

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


message(STATUS "AUTOTOOL_HOST=${AUTOTOOL_HOST}")

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

message(STATUS "CMAKE_C_COMPILER=${CMAKE_C_COMPILER}")

if(BUILD_PLATFORM MATCHES "ubuntu_x86-64")
    add_custom_target(
        ALL
        DEPENDS ${ZLIB_TARGET}
        DEPENDS ${JPEG_TARGET}
        DEPENDS ${OPENDDS_TARGET}
        DEPENDS ${OPENCV_TARGET}
        )
elseif(BUILD_PLATFORM MATCHES "renesas_v3h_aarch64")
    add_custom_target(
        ALL
        DEPENDS ${ZLIB_TARGET}
        DEPENDS ${JPEG_TARGET}
        DEPENDS ${OPENDDS_TARGET}
        DEPENDS ${OPENCV_TARGET}
        DEPENDS test_main
        )
endif()

