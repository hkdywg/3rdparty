OPTION(OPENCV_WITH_CUDA "" OFF)
OPTION(OPENCV_WITH_OPENCL "" OFF)
OPTION(OPENCV_WITH_GTK "" OFF)

set(OPENCV_VERSION 3.3.1)
set(OPENCV_PACKAGE_NAME opencv-${OPENCV_VERSION})
set(OPENCV_PACKAGE_PATH ${CMAKE_CURRENT_LIST_DIR}/${OPENCV_PACKAGE_NAME}.tar.bz2)

set(OPENCV_PREFIX ${THIRDPARTY_ROOT}/build/install)

GENERATE_PATCH_COMMAND(OPENCV_PACKAGE_PATCH_CMD ${OPENCV_PACKAGE_NAME})

find_package(
        Opencv ${OPENCV_VERSION} QUIET COMPONENTS
        calib3d
        core
        features2d
        flann
        highgui
        imgcodecs
        imgproc
        xfeatures2d
        aruco
        video
        videoio
    )

set(OPENCV_TARGET ${OPENCV_PACKAGE_NAME})

unset(OPENCV_BUILD_ARGS)

if(CMAKE_CROSSCOMPILING)
    list(APPEND OPENCV_BUILD_ARGS "-DCMAKE_TOOLCHAIN_FILE=${CROSS_TOOLCHAIN_CONFIG_FILE}")    
endif()

list(APPEND OPENCV_BUILD_ARGS "-DCMAKE_BUILD_TYPE=RELEASE")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_DOCS=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_EXAMPLES=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_TESTS=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_opencv_apps=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_opencv_ml=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_opencv_dnn=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_opencv_photo=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_opencv_superres=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_opencv_videostab=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_opencv_objdetect=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_opencv_dfm=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_opencv_shape=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_opencv_stitching=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_opencv_videoio=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_PERF_TESTS=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DWITH_CUDA=${OPENCV_WITH_CUDA}")
list(APPEND OPENCV_BUILD_ARGS "-DWITH_OPENCL=${OPENCV_WITH_OPENCL}")
list(APPEND OPENCV_BUILD_ARGS "-DWITH_GTK=${OPENCV_WITH_GTK}")
list(APPEND OPENCV_BUILD_ARGS "-DWITH_1394=${OPENCV_WITH_1394}")
list(APPEND OPENCV_BUILD_ARGS "-DWITH_GSTREAMER=${OPENCV_WITH_GSTREAMER}")
list(APPEND OPENCV_BUILD_ARGS "-DWITH_GPHOTO2=${OPENCV_WITH_GPHOTO2}")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_FAT_JAVA_LIB=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DENABLE_CXX11=ON")
list(APPEND OPENCV_BUILD_ARGS "-DENABLE_PRECOMPILED_HEADERS=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DBUILD_opencv_python2=OFF")
list(APPEND OPENCV_BUILD_ARGS "-DOPENCV_EXTRA_MODULES_PATH=../${OPENCV_PACKAGE_NAME}/opencv_contrib-${OPENCV_VERSION}/modules")
list(APPEND OPENCV_BUILD_ARGS "-DCMAKE_INSTALL_PREFIX:PATH=${OPENCV_PREFIX}")
list(APPEND OPENCV_BUILD_ARGS "-DCMAKE_EXPORT_NO_PACKAGE_RESISTRY=ON")
list(APPEND OPENCV_BUILD_ARGS "-DCMAKE_POSITION_INDEPENDENT_CODE=ON")
list(APPEND OPENCV_BUILD_ARGS "-DCMAKE_INSTALL_PATH=$ORIGIN")
list(APPEND OPENCV_BUILD_ARGS "${VERBOSE_CMAKE}")

THIRDPARTY_CACHE_SEARCH(opencv ${OPENCV_PACKAGE_NAME})
if(${OPENCV_PACKAGE_NAME}_CACHE_FOUND)
    ExternalProject_Add(
        ${OPENCV_TARGET}
        URL ${OPENCV_PACKAGE_PATH}
        PATCH_COMMAND "${OPENCV_PACKAGE_PATCH_CMD}"
        LIST_SEPARATOR |
        CMAKE_ARGS
        ${OPENCV_BUILD_ARGS}
        )
endif()

find_program(CHRPATH chrpath)

if(CHRPATH)
    set(_opencv_libraries
            libopencv_calib3d.so
            libopencv_feature2d.so
            libopencv_highgui.so
            libopencv_imgproc.so
            libopencv_core.so
            libopencv_flann.so
            libopencv_imgcodecs.so
            libopencv_xfatures2d.so
            libopencv_aruco.so
            libopencv_video.so
        )

    add_custom_command(TARGET ${OPENCV_TARGET} POST_BUILD COMMAND
            for lib in ${_opencv_libraries}\; do ${CHRPATH} -r "'\$$ORIGIN'" $$lib \; done \; echo ""
            WORKING_DIRECTORY ${OPENCV_PREFIX}/lib
            COMMENT "Change runpath for opencv libraries: ${_opencv_libraries}"
        )
endif()


add_custom_target(opencv DEPENDS ${OPENCV_TARGET})

set(OPENCV_PREFIX ${OPENCV_PREFIX} PARENT_SCOPE)
set(OPENCV_TARGET ${OPENCV_TARGET} PARENT_SCOPE)
