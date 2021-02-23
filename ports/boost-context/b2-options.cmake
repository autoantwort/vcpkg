message(STATUS "VCPKG_TARGET_IS_WINDOWS: ${VCPKG_TARGET_IS_WINDOWS}")
if(${VCPKG_TARGET_IS_WINDOWS})
    message(STATUS "test1")
endif()
if(VCPKG_TARGET_IS_WINDOWS)
    message(STATUS "test2")
endif()
if(VCPKG_TARGET_IS_WINDOWS)
    list(APPEND B2_OPTIONS
        abi=ms
        binary-format=pe
    )
endif()
