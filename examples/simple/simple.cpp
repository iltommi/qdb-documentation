/**
 * Copyright (c) 2009-2011, Bureau 14 SARL
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *    * Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *    * Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *    * Neither the name of the University of California, Berkeley nor the
 *      names of its contributors may be used to endorse or promote products
 *      derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY BUREAU 14 AND CONTRIBUTORS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <clocale>
#include <iostream>
#include <exception>

#include <wrp_me/dynlib/wrp_me_dl.h>

int main(int argc, char ** argv, char ** envp)
{

    std::setlocale(LC_ALL, "en_US.UTF-8");

    // first and foremost one need to create an engine instance

    // an instance needs a configuration which is a wrp_me_config_t
    // structure.

    // you will see abundant usage of the wrp_me_string_t which resembles
    // Windows NT's UNICODE_STRING structure
    // see RtlInitUnicodeString and friends on the MSDN
    
    // wrp_me_string_t structures are meant to be acceded with
    // the wrp_me_init_str, wrp_me_alloc_str, wrp_me_copy_str, 
    // wrp_me_alloc_copy_str and wrp_me_free_str functions.
    // although one may play directly with the structure
    // members, it is advised to use the helpers function
    // as much as possible.

    wrp_me_config_t config;

    // the path to the *directory* where the engine content is
    // serialized.
    // if the directory exists and contains a database, its content
    // will be loaded.
    wrp_me_init_str(&config._db_dir, "db");

    // the duration, in seconds, between each serialization to the disk
    // of the engine's internal state.
    config._flush_interval = 2.0;

    // path to the log file. The path may be absolute or relative
    if (wrp_me_init_str(&config._log_file, "simple.log") != WRP_ME_SUCCESS)
    {
        // in our example, this cannot happen, but you should always
        // check the return values of the functions
        std::cerr << "String init error" << std::endl;
        return 1;
    }

    // wrpme's log is asynchronous, this specifies the interval, 
    // in seconds, between each log flush.
    // asynchronous logging shows as much we thought through the 
    // design of wrpme to make sure that nothing stays in the
    // way of parallel processing.
    config._log_flush_interval = 1.0;

    // log level, 0 is the most verbose, 5 the least
    config._log_level = 0;

    // this creates an engine instance, a null handle indicates an
    // error.
    // errors at creation can only be caused by invalid configuration
    // or (very) low memory conditions.
    // several instances of wrpme in the same process are possible 
    // (although not very useful) but behavior is undefined if the
    // database directory is shared amongst these instances.
    wrp_me_handle handle = wrp_me_create(&config);

    if (!handle)
    {
        std::cerr << "Unable to initialize the engine. ";
        std::cerr << "Please validate your configuration." << std::endl;
        return 1;
    }

    // the wrpme handle is thread safe, you can add, update, remove
    // in separate threads without any lock!

    // the wrpme handle is valid for the current process only.

    // thanks to it's modern architecture, wrpme will optimize
    // the load over the different cores of your machine
    // and will do everything it can to serve as many requests
    // in parallel.

    // of course what actual data you may eventually have inside
    // the engine will depend on the order of execution
    // although it may sound scary, in practice this is really
    // not an issue.

    try
    {
        // we now have an engine instance which is either empty or loaded
        // with the content of the database

        // let's play with the engine a bit, shall we?

        // let's look for an alias named "my_alias"
        // an alias name may not be larger than WRP_ME_STRING_MAX_LENGTH characters
        // and must be UTF-8 encoded (if it contains special characters) and 0 
        // terminated
        wrp_me_string_t alias;
        if (wrp_me_init_str(&alias, "my_alias") != WRP_ME_SUCCESS)
        {
            throw std::runtime_error("wrpme string initialization error");
        }

        // we will need a buffer for the result, this is wrp_me_string_t
        // there is no limit to the size of an alias except the amount of available
        // contiguous virtual memory
        // on a 64-bit system this can be very large, but remember the engine
        // will under perform under low memory conditions!
        // the content is just raw binary data which may not be zero terminated

        // if you want to go beyond WRP_ME_STRING_MAX_LENGTH, you need
        // to manually allocated and initialize the wrp_me_string_t structure

        wrp_me_string_t result;
        if (wrp_me_alloc_str(&result, WRP_ME_STRING_MAX_LENGTH) != WRP_ME_SUCCESS)
        {
            throw std::runtime_error("wrpme string initialization error");
        }

        // the search is obvious, specify the handle
        // the alias and where you want your result!
        // very little copy occurs when making these calls, the engine directly
        // works on the provided buffers for maximum performance
        // functions don't throw exceptions as they are designed to be called from
        // any languages working with C interfaces
        int r = wrp_me_find(handle, &alias, &result);

        switch(r)
        {
        case WRP_ME_SUCCESS:
            // we display the content of the alias because we know it's zero terminated
            // keep in mind this may not be the case as we accept any raw binary
            // data in real life
            std::cout << "Found the following content for the entry " << alias._buffer
                << " : " << result._buffer << std::endl;
            break;

        case WRP_ME_NOT_FOUND:
            std::cout << "There is no content for the entry " << alias._buffer << std::endl;
            break;

        default:
            std::cerr << "An error occured. Code = " << r << std::endl;
            throw std::runtime_error("wrpme engine error.");
        }

        // you can use extended characters as aliases, but it must be UTF-8 encoded
        // and zero terminated
        wrp_me_string_t author;
        if (wrp_me_init_str(&author, "白居易") != WRP_ME_SUCCESS)
        {
            throw std::runtime_error("wrpme string initialization error");
        }

        // content is just raw data, it doesn't matter what it is if you know how 
        // to process it
        wrp_me_string_t poem;
        if (wrp_me_init_str(&poem, 
                "孤山寺北贾亭西"
                "水面初平云脚低"
                "几处早莺争暖树"
                "谁家新燕啄春泥"
                "乱花渐欲迷人眼"
                "浅草才能没马蹄"
                "最爱湖东行不足"
                "绿杨阴里白沙堤") != WRP_ME_SUCCESS)
        {
            throw std::runtime_error("wrpme string initialization error");
        }

        // update "always works", as long as you have memory available ! :-)
        // if the entry exists, it's updated to the new content,
        // if the entry doesn't exist, it's created
        // if you want a stricter behaviour, then you can use wrp_me_add
        // which fails when the entry already exists
        r = wrp_me_update(handle, &author, &poem);
        if (r != WRP_ME_SUCCESS)
        {
            std::cerr << "An error occured. Code = " << r << std::endl;
            throw std::runtime_error("wrpme engine error.");
        }

        // wrpme never removes entry without an explicit request
        // so this find must be successful
        r = wrp_me_find(handle, &author, &result);
        if (r != WRP_ME_SUCCESS)
        {
            std::cerr << "An error occured. Code = " << r << std::endl;
            throw std::runtime_error("wrpme engine error.");
        }

        // careful... wrpme doesn't assume the content should be 0 terminated
        // so we got no zero terminal and we have to add it
        // you need to manually work on the wrp_me_string_t and avoid
        // the helpers function when working with raw data
        result._buffer[result._length] = '\0';

        // you will need a properly set up console to display this correctly
        // using an Asian capable font such as Arial Unicode MS
        std::cout << "Today's poem: " << result._buffer << std::endl;
        std::cout << author._buffer << std::endl;

        // you can remove entries at any time
        if (wrp_me_remove(handle, &author) != WRP_ME_SUCCESS)
        {
            std::cerr << "An error occured. Code = " << result._buffer << std::endl;
            throw std::runtime_error("wrpme engine error.");
        }

        // strings allocated by wrp_me_alloc_str or wrp_me_copy_alloc_str
        // must be freed explicitly
        wrp_me_free_str(&result);

    }
    catch (const std::exception & e)
    {
        std::cerr << "Exception caught! " << e.what() << std::endl;
    }
    
    if (handle)
    {
        // this will shut down the engine, flushes all content to disk and free
        // all allocated resources
        // note that releasing wrpme can take a couple of seconds
        // as we're waiting for all the threads to sync back
        wrp_me_release(handle);
    }

    return 0;
}
