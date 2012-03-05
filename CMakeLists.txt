# copies the nginx plugin source code

set(README_TXT_FILE ${CMAKE_CURRENT_SOURCE_DIR}/README.txt PARENT_SCOPE)

install(FILES 
    license.txt
    README.txt
    DESTINATION doc)

