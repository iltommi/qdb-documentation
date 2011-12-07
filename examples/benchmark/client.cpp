#include <wrp_me/client/wrp_me_api.h>
#include <tbb/tick_count.h>
#include <iostream>

int main(int, char**)
{
    static const char host[] = "127.0.0.1";
    static const unsigned short port = 5912;
    static const size_t content_size = 128;
    static const size_t get_count = 100000;
    static const char alias[] = "alias";
    static const char content[content_size] = {0};
    char output[content_size] = {0};

    wrp_me_handle_t handle;
    if( wrp_me_e_ok != wrp_me_open(&handle, wrp_me_p_tcp) )
    {
        std::cout << "failed to open handle" << std::endl;
        return 1;
    }
        
    if( wrp_me_e_ok != wrp_me_connect(handle, host, port) )
    {
        std::cout << "failed to connect to server" << std::endl;
        return 1;
    }
            
    if( wrp_me_e_ok != wrp_me_put(handle, alias, content, sizeof(content)) )
    {
        std::cout << "failed to put data in cache" << std::endl;
        return 1;
    }

    tbb::tick_count t0 = tbb::tick_count::now();
    for(size_t i = 0; i < get_count; ++i)
    {
        size_t retrieved_size = content_size;
        wrp_me_get(handle, alias, output, &retrieved_size);
    }
    double time = (tbb::tick_count::now() - t0).seconds();

    std::cout << "preformed " << get_count << " get operations in " << time << " seconds" << std::endl;
    return 0;
}
