# Supported Values: Linux, QNX, Android, Window, Generic(For Embedded system)
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64-poky)

if(${CMAKE_VERSION} VERSION_GREATER 3.7.0)
    set(FLAGS_SUFFIX _INIT) # 3.7.x introduced new _INIT variables for toolchainfile flags
else()
    set(FLAGS_SUFFIX)
endif()

set(BUILD_PLATFORM "v3h_aarch64")

# Set cross compiler tool path
if(ENV{CROSS_TOOL_CHAIN_PATH})
    set(TOOLCHAIN_PATH $ENV{CROSS_TOOL_CHAIN_PATH})
else()
    set(CMAKE_SYSROOT /opt/poky/3.0.2/sysroots/aarch64-poky-linux)
    set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})
    set(TOOLCHAIN_PATH /opt/poky/3.0.2/sysroots/x86_64-pokysdk-linux/usr/bin/aarch64-poky-linux)
endif()

message(STATUS "TOOLCHAIN_PATH = ${TOOLCHAIN_PATH}")

find_program(CMAKE_C_COMPILER       NAMES   "aarch64-poky-linux-gcc"        PATHS   ${TOOLCHAIN_PATH})
find_program(CMAKE_CXX_COMPILER     NAMES   "aarch64-poky-linux-g++"        PATHS   ${TOOLCHAIN_PATH})
find_program(CMAKE_ASM_COMPILER     NAMES   "aarch64-poky-linux-gcc"        PATHS   ${TOOLCHAIN_PATH})
find_program(CMAKE_RANLIB           NAMES   "aarch64-poky-linux-ranlib"     PATHS   ${TOOLCHAIN_PATH})
find_program(CMAKE_AR               NAMES   "aarch64-poky-linux-ar"         PATHS   ${TOOLCHAIN_PATH})
find_program(CMAKE_AS               NAMES   "aarch64-poky-linux-as"         PATHS   ${TOOLCHAIN_PATH})
find_program(CMAKE_LD               NAMES   "aarch64-poky-linux-ld"         PATHS   ${TOOLCHAIN_PATH})
find_program(CMAKE_NM               NAMES   "aarch64-poky-linux-nm"         PATHS   ${TOOLCHAIN_PATH})
find_program(CMAKE_GDB              NAMES   "aarch64-poky-linux-gdb"        PATHS   ${TOOLCHAIN_PATH})
find_program(CMAKE_STRIP            NAMES   "aarch64-poky-linux-strip"      PATHS   ${TOOLCHAIN_PATH})
find_program(CMAKE_GDB              NAMES   "aarch64-poky-linux-gdb"        PATHS   ${TOOLCHAIN_PATH})
find_program(CMAKE_OBJCOPY          NAMES   "aarch64-poky-linux-objcopy"    PATHS   ${TOOLCHAIN_PATH})
find_program(CMAKE_OBJDUMP          NAMES   "aarch64-poky-linux-objdump"    PATHS   ${TOOLCHAIN_PATH})

message(STATUS "CMAKE_C_COMPILER = ${CMAKE_C_COMPILER}")
message(STATUS "CMAKE_CXX_COMPILER = ${CMAKE_CXX_COMPILER}")
message(STATUS "CMAKE_ASM_COMPILER = ${CMAKE_ASM_COMPILER}")


if(NOT CMAKE_C_COMPILER)
    message(FATAL_ERROR "CMAKE_C_COMPILER not found")
endif()

if(NOT CMAKE_CXX_COMPILER)
    message(FATAL_ERROR "CMAKE_CXX_COMPILER not found")
endif()

if(NOT CMAKE_ASM_COMPILER)
    message(FATAL_ERROR "CMAKE_ASM_COMPILER not found")
endif()

if(NOT CMAKE_AR)
    message(FATAL_ERROR "CMAKE_AR not found")
endif()

set(CMAKE_SYSROOT ${CMAKE_FIND_ROOT_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

set(CMAKE_ASM_FLAGS${FLAGS_SUFFIX} "--sysroot=${CMAKE_FIND_ROOT_PATH}")
set(CMAKE_C_COMPILER_TARGET aarch64-poky-linux)
set(CMAKE_C_FLAGS${FLAGS_SUFFIX} "--sysroot=${CMAKE_FIND_ROOT_PATH}")
set(CMAKE_CXX_COMPILER_TARGET aarch64-poky-linux)
set(CMAKE_CXX_FLAGS${FLAGS_SUFFIX} "--sysroot=${CMAKE_FIND_ROOT_PATH}")

set(CMAKE_EXE_LINKER_FLAGS${FLAGS_SUFFIX} "--sysroot=${CMAKE_FIND_ROOT_PATH}")


message(STATUS "cross tool chain is configure")
