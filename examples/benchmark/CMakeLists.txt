include_directories( ${Boost_INCLUDE_DIRS} 
    ${Tbb_INCLUDE_DIR}
    ${WRP_ME_INCLUDE})

set(BENCHMARK_IDE_FOLDER "Benchmarks")

add_executable(wrp_me_bench_server
    server.cpp)
        
set_target_properties(wrp_me_bench_server PROPERTIES 
    DEBUG_POSTFIX ${WRPME_DEBUG_POSTFIX} 
    FOLDER ${BENCHMARK_IDE_FOLDER})
        
target_link_libraries(wrp_me_bench_server

    ${Tbb_MALLOC_LIBRARIES}
    ${Tbb_LIBRARIES}

    wrp_me_api
    wrp_me_log
    wrp_me_server
    wrp_me_sys
    wrp_me_log    
    wrp_me
    leveldb

    ${Boost_FILESYSTEM_LIBRARY}
    ${Boost_SYSTEM_LIBRARY}
    ${Boost_DATE_TIME_LIBRARY}
    ${Boost_THREAD_LIBRARY}
    ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY}
    ${Boost_PRG_EXEC_MONITOR_LIBRARY}

    ${Pthread_LIBRARY} )
    
add_executable(wrp_me_bench_client
    client.cpp)
    
set_target_properties(wrp_me_bench_client PROPERTIES 
    DEBUG_POSTFIX ${WRPME_DEBUG_POSTFIX} 
    FOLDER ${BENCHMARK_IDE_FOLDER})
        
target_link_libraries(wrp_me_bench_client

    ${Tbb_LIBRARIES}

    wrp_me_api

    ${Pthread_LIBRARY}
    ${Stdcpp_LIBRARY} )

install(FILES 
    server.cpp
    client.cpp
    DESTINATION doc/examples/benchmark)
