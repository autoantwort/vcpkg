vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO uNetworking/uWebSockets
    REF 6f1c0d802221b5eaae49acef8c2cfa48433583fb # v19.0.0
    SHA512 ed648c7e1a422531a8e3fdcbc7c659fbe96e7c7e430b1924471ef13b49a12f7306fdf32df839f7572a2b8ca0e3a443fe1fa01bc368e2fc4d6f928b3803fe5d4c
    HEAD_REF master
)

file(COPY ${SOURCE_PATH}/src  DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(RENAME ${CURRENT_PACKAGES_DIR}/include/src ${CURRENT_PACKAGES_DIR}/include/uwebsockets/)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
