set(README_TXT_FILE ${CMAKE_CURRENT_SOURCE_DIR}/README.txt PARENT_SCOPE)

if(CMAKE_SYSTEM_NAME STREQUAL "FreeBSD")
    set(MAKE "gmake")
else()
    set(MAKE "make")
endif()     

if(CMAKE_BUILD_TYPE STREQUAL "Release")

    add_custom_target(build_doc ALL
        COMMAND ${MAKE} html 
        COMMENT "Building documentation with Sphinx"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        VERBATIM)
    
    install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build/html/
        DESTINATION html
        COMPONENT doc)

endif()

install(FILES 
    license.txt
    README.txt
    DESTINATION .
    COMPONENT doc)
