#vcpkg_from_github(
#    OUT_SOURCE_PATH TCL_SOURCE_PATH
#    REPO tcltk/tcl
#    REF 17b5b3e0201cdf92d3c125776e1b2dd453f225bd # tag core-8-6-11
#    SHA512 ad7096bbb579afb6969b0a3db4d797078dbc78c204c76d3dd2f2cc7b6109135c547e151c3dd1282fbf1d51b448da6c663868fcfec2b544e68e89e5104591761c
    #PATCHES force-shell-install.patch
#)

vcpkg_download_distfile(
    TCL_ZIP
    URLS https://deac-riga.dl.sourceforge.net/project/tcl/Tcl/8.6.11/tcl8611-src.zip
    FILENAME tcl.zip
    SHA512 f5a6f8c35fe8f924142cb30abc5634dcf3480e03479d9f19f7c658d0a110704d84ec4b02ea9b56332b20a590bcdba44d78c31d04f3ad67d09265ca12b1f0586e
)

vcpkg_extract_source_archive(
    TCL_SOURCE_PATH
    ARCHIVE "${TCL_ZIP}"
)

#vcpkg_from_github(
#    OUT_SOURCE_PATH TK_SOURCE_PATH
#    REPO tcltk/tk
#    REF 86f2568af121eef578eb52d2660aa22d8448bbf5 # tag core-8-6-11
#    SHA512 e552022f18f39016fe81374e0e46628bd2f521d7fc552e36f2d3159f1c245e98860b946713e13ca8640cfee11ff0c0597b06caeb1a693bb966d49f0fa26b51eb
    # PATCHES force-shell-install.patch
#)

vcpkg_download_distfile(
    TK_ZIP
    URLS https://deac-riga.dl.sourceforge.net/project/tcl/Tcl/8.6.11/tk86111-src.zip
    FILENAME tk.zip
    SHA512 aecc5d740a007a397e02adfc02ed8b330971fedcab34daf9a23821334e57f2e3502deeb612a35f1b5c89d3827770e56e571aeeecfd398ca228a9d88887643507
)

vcpkg_extract_source_archive(
    TK_SOURCE_PATH
    ARCHIVE "${TK_ZIP}"
)

if (VCPKG_TARGET_IS_WINDOWS)
    if(VCPKG_TARGET_ARCHITECTURE MATCHES "x64")
        set(TCL_BUILD_MACHINE_STR MACHINE=AMD64)
    else()
        set(TCL_BUILD_MACHINE_STR MACHINE=IX86)
    endif()

    set(VCPKG_POLICY_MISMATCHED_NUMBER_OF_BINARIES enabled)
    # from https://www.tcl.tk/doc/howto/compile.html "Compiling on Windows"

    vcpkg_install_nmake(
        SOURCE_PATH ${TCL_SOURCE_PATH}
        NO_DEBUG
        PROJECT_SUBPATH win
        OPTIONS
            ${TCL_BUILD_MACHINE_STR}
            OPTS=static,staticpkg,utfmax,pdbs
            CHECKS=64bit
            SCRIPT_INSTALL_DIR=${CURRENT_PACKAGES_DIR}/share/${PORT}/lib/tcl8.6
        OPTIONS_RELEASE
            release
    )
    set(TCL_BUILD_DIR "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-tcl")
    file(REMOVE_RECURSE "${TCL_BUILD_DIR}")
    file(RENAME "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}" "${TCL_BUILD_DIR}")
    
    vcpkg_install_nmake(
        SOURCE_PATH ${TK_SOURCE_PATH}
        NO_DEBUG
        PROJECT_SUBPATH win
        OPTIONS
            ${TCL_BUILD_MACHINE_STR}
            TCLDIR=${TCL_BUILD_DIR}
            OPTS=static,staticpkg,utfmax,pdbs
            CHECKS=64bit
            SCRIPT_INSTALL_DIR=${CURRENT_PACKAGES_DIR}/share/${PORT}/lib/tk8.6
        OPTIONS_RELEASE
            release
    )


    # Install
    # Note: tcl shell requires it to be in a folder adjacent to the /lib/ folder, i.e. in a /bin/ folder
    if (NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL release)
        file(GLOB_RECURSE TOOL_BIN
                ${CURRENT_PACKAGES_DIR}/bin/*.exe
                ${CURRENT_PACKAGES_DIR}/bin/*.dll
        )
        file(COPY ${TOOL_BIN} DESTINATION ${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin/)

        # Remove .exes only after copying
        file(GLOB_RECURSE TOOL_EXES ${CURRENT_PACKAGES_DIR}/bin/*.exe)
        file(REMOVE ${TOOL_EXES})
        
        foreach(TOOL itcl4.2.1 nmake sqlite3.34.0 tcl8 tdbc1.1.2 tdbcmysql1.1.2 tdbcodbc1.1.2 tdbcpostgres1.1.2 tdbcsqlite31.1.2 thread2.8.6)
            message("Rename : ${TOOL} from ${CURRENT_PACKAGES_DIR}/lib/${TOOL} to ${CURRENT_PACKAGES_DIR}/share/${PORT}/lib/${TOOL}")
            file(RENAME "${CURRENT_PACKAGES_DIR}/lib/${TOOL}" "${CURRENT_PACKAGES_DIR}/share/${PORT}/lib/${TOOL}")
        endforeach()
    endif()
    
    if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
        file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
    endif()
    
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
    
else()
    # file(REMOVE "${SOURCE_PATH}/unix/configure")
    vcpkg_configure_make(
        SOURCE_PATH ${SOURCE_PATH}
        NO_ADDITIONAL_PATHS
        PROJECT_SUBPATH unix
        OPTIONS
            
    )
    
    vcpkg_install_make()
    vcpkg_fixup_pkgconfig()
    
    if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
        file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
    endif()
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/tools/tcl/debug")
file(CHMOD_RECURSE "${CURRENT_PACKAGES_DIR}/share/tcltk/lib/tcl8.6/msgs" "${CURRENT_PACKAGES_DIR}/share/tcltk/lib/tcl8.6/tzdata"
        PERMISSIONS
            OWNER_READ OWNER_WRITE OWNER_EXECUTE
            GROUP_READ GROUP_WRITE GROUP_EXECUTE
            WORLD_READ WORLD_WRITE WORLD_EXECUTE
    )

file(INSTALL ${TCL_SOURCE_PATH}/license.terms DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
