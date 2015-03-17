if(NOT CMAKE_BUILD_TYPE MATCHES "Release")
    message(STATUS "Not building documentation because CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}")
    return()
endif()

find_program(SPHINX sphinx-build)
if(SPHINX)
    message(STATUS "Found Sphinx: ${SPHINX}")
else()
    message(WARNING "sphinx-build not found, please run 'pip install sphinx'")
    set(MISSING_PROGRAMS TRUE)
endif()

find_program(JAVASPHINX javasphinx-apidoc)
if(JAVASPHINX)
    message(STATUS "Found JavaShinx: ${SPHINX}")
else()
    message(WARNING "javasphinx-apidoc not found, please run 'pip install javasphinx'")
    set(MISSING_PROGRAMS TRUE)
endif()

if(${MISSING_PROGRAMS})
    message("Not building documentation because required programs are not found")
    return()
endif()

set(README_TXT_FILE ${CMAKE_CURRENT_SOURCE_DIR}/README.txt PARENT_SCOPE)
set(DOC_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build/html/)
set(INDEX_HTML ${DOC_OUTPUT_DIRECTORY}/index.html)
file(GLOB_RECURSE DOC_INPUT_FILES *.*)

if(CMAKE_SYSTEM_NAME STREQUAL "FreeBSD")
    set(MAKE "gmake")
else()
    set(MAKE "make")
endif()

add_custom_command(
    OUTPUT ${INDEX_HTML}
    COMMAND ${MAKE} html    
    DEPENDS ${DOC_INPUT_FILES}
    COMMENT "Building documentation with Sphinx"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

add_custom_target(qdb_documentation ALL
    DEPENDS ${INDEX_HTML}
    SOURCES ${DOC_INPUT_FILES}
)

add_dependencies(qdb_documentation qdb_python_api)

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build/html/
    DESTINATION html
    COMPONENT doc
    OPTIONAL
)

install(FILES 
    license.txt
    README.txt
    DESTINATION .
    COMPONENT doc
)
