message(STATUS "VCPKG_TARGET_IS_WINDOWS: ${VCPKG_TARGET_IS_WINDOWS}")
    list(APPEND B2_OPTIONS
        abi=ms
        binary-format=pe
    )
