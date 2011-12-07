#include <wrp_me/server/simple_node.hpp>
#include <wrp_me/log/logger.hpp>

using namespace wrp_me;

int main(int, char**)
{
    using boost::fusion::at_key;

    static const char host[] = "127.0.0.1";
    static const unsigned short port = 5912;

    config::directory config;
    at_key<config::chord>(config).listen_on = boost::asio::ip::tcp::endpoint(boost::asio::ip::address::from_string(host), port);
    at_key<config::chord>(config).node_id = chord::id(1);
    at_key<config::server>(config).idle_timeout = 5;
    at_key<config::depot>(config).flush_interval = 0;
    at_key<config::logger>(config).log_to_console = true;

    simple_node server(config);

    server.let_there_be_light();
    server.wait_termination();

    std::cout << "server shutting down" << std::endl;
    return 0;
}
