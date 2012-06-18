# copies the nginx plugin source code

set(README_TXT_FILE ${CMAKE_CURRENT_SOURCE_DIR}/README.txt PARENT_SCOPE)

add_custom_target(build_doc 
    COMMAND make html 
    COMMENT "Build documentation with Sphinx"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

install(FILES 
    license.txt
    README.txt
    DESTINATION doc)

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build/html/
    DESTINATION doc/html)

