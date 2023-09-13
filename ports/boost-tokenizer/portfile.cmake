# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/tokenizer
    REF boost-1.83.0
    SHA512 25e3aca064a1aeff65cd9abd8e828a1a25c2f4411d8e66f1bda7bccb9fc30145923eb1ca79d9ae8328584305a4d88e517897b870d45eca17923038edc58619f5
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
