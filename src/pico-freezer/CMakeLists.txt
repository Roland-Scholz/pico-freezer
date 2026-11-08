# Generated Cmake Pico project file

cmake_minimum_required(VERSION 3.13)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Initialise pico_sdk from installed location
# (note this can come from environment, CMake cache etc)

# == DO NOT EDIT THE FOLLOWING LINES for the Raspberry Pi Pico VS Code Extension to work ==
if(WIN32)
    set(USERHOME $ENV{USERPROFILE})
else()
    set(USERHOME $ENV{HOME})
endif()
set(sdkVersion 2.3.1)
set(toolchainVersion 15_2_Rel1)
set(picotoolVersion 2.3.1)
set(picoVscode ${USERHOME}/.pico-sdk/cmake/pico-vscode.cmake)
if (EXISTS ${picoVscode})
    include(${picoVscode})
endif()
# ====================================================================================
set(PICO_BOARD pico CACHE STRING "Board type")

# Pull in Raspberry Pi Pico SDK (must be before project)
include(pico_sdk_import.cmake)

project(pico-freezer C CXX ASM)

# Initialise the Raspberry Pi Pico SDK
pico_sdk_init()

#no debug, high optimization
# 1. Standard-Build-Typ permanent auf Release setzen
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
endif()

# 2. Debug-Symbole (-g) für Release komplett abschalten und maximale Optimierung (-O3) erzwingen
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_ASM_FLAGS_RELEASE "-O3" CACHE STRING "" FORCE)


# Add executable. Default name is the project name, version 0.1
add_executable(pico-freezer pico-freezer.c freezer_function.S)

pico_set_program_name(pico-freezer "pico-freezer")
pico_set_program_version(pico-freezer "0.1")

# no_flash means the target is to run from RAM
pico_set_binary_type(pico-freezer default)
#pico_set_binary_type(pico-freezer copy_to_ram)

# Modify the below lines to enable/disable output over UART/USB
pico_enable_stdio_uart(pico-freezer 0)
pico_enable_stdio_usb(pico-freezer 1)

#target_link_options(pico-freezer PRIVATE "-Wl,--no-relax")

# Add the standard library to the build
target_link_libraries(pico-freezer
        pico_stdlib
        pico_multicore  
        hardware_vreg
        hardware_clocks)

target_compile_definitions(pico-freezer PRIVATE
    PICO_PLL_VCO_MIN_FREQ_KHZ=400000
    PICO_PLL_VCO_MAX_FREQ_KHZ=1600000
)

#target_compile_definitions(pico-freezer PRIVATE
#    PICO_PLL_VCO_MIN_FREQ_MHZ=400
#    PICO_PLL_VCO_MAX_FREQ_MHZ=1600
#)

# Add the standard include files to the build
target_include_directories(pico-freezer PRIVATE
        ${CMAKE_CURRENT_LIST_DIR}
)

pico_add_extra_outputs(pico-freezer)

