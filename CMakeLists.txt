# copies the nginx plugin source code

set(README_TXT_FILE ${CMAKE_CURRENT_SOURCE_DIR}/README.txt PARENT_SCOPE)

if(CMAKE_BUILD_TYPE STREQUAL Release)
    IF(${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
        add_custom_target(build_doc ALL
                COMMAND gmake html 
                COMMENT "Build documentation with Sphinx"
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                VERBATIM)
    else(${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
        add_custom_target(build_doc ALL
            COMMAND make html 
            COMMENT "Build documentation with Sphinx"
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            VERBATIM)
    endif(${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
endif(CMAKE_BUILD_TYPE STREQUAL Release)

install(FILES 
    license.txt
    README.txt
    DESTINATION doc)

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build/html/
    DESTINATION doc/html)

