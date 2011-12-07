
include_directories(
    ${WRP_ME_INCLUDE})

set(EXAMPLE_IDE_FOLDER "Examples")

add_executable(wrp_me_get
    get.c)
        
set_target_properties(wrp_me_get PROPERTIES 
    DEBUG_POSTFIX ${WRPME_DEBUG_POSTFIX} 
    FOLDER ${EXAMPLE_IDE_FOLDER})
        
target_link_libraries(wrp_me_get
    wrp_me_api
    ${Pthread_LIBRARY}
    ${Stdcpp_LIBRARY})  
    
add_executable(wrp_me_get_buffer
    get_buffer.c)
    
set_target_properties(wrp_me_get_buffer PROPERTIES 
    DEBUG_POSTFIX ${WRPME_DEBUG_POSTFIX} 
    FOLDER ${EXAMPLE_IDE_FOLDER})
        
target_link_libraries(wrp_me_get_buffer
    wrp_me_api
    ${Pthread_LIBRARY}
    ${Stdcpp_LIBRARY})

add_executable(wrp_me_put
    put.c)
        
set_target_properties(wrp_me_put PROPERTIES 
    DEBUG_POSTFIX ${WRPME_DEBUG_POSTFIX} 
    FOLDER ${EXAMPLE_IDE_FOLDER})
        
target_link_libraries(wrp_me_put
    wrp_me_api
    ${Pthread_LIBRARY}
    ${Stdcpp_LIBRARY})

add_executable(wrp_me_update
    update.c)
    
set_target_properties(wrp_me_update PROPERTIES 
    DEBUG_POSTFIX ${WRPME_DEBUG_POSTFIX} 
    FOLDER ${EXAMPLE_IDE_FOLDER})
        
target_link_libraries(wrp_me_update
    wrp_me_api
    ${Pthread_LIBRARY}
    ${Stdcpp_LIBRARY})

add_executable(wrp_me_delete
    delete.c)
    
set_target_properties(wrp_me_delete PROPERTIES 
    DEBUG_POSTFIX ${WRPME_DEBUG_POSTFIX} 
    FOLDER ${EXAMPLE_IDE_FOLDER})
        
target_link_libraries(wrp_me_delete
    wrp_me_api
    ${Pthread_LIBRARY}
    ${Stdcpp_LIBRARY})

install(FILES 
    delete.c
    get.c
    get_buffer.c
    put.c
    update.c    
    DESTINATION doc/examples/c)
