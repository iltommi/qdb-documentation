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
 
import com.b14.wrpme.jni.*;

public class WrpmeRawExample
{
    static
    {
        // wrpme for Java is available as a JNI API

        // you need to load the native dynamic link library
        // you will also need to make sure all dependencies are resolved
        // this means having the TBB libraries and the wrp_me C API (wrp_me_api)
        // on Windows you will also need to make sure you have the Visual Studio 2010 runtime
        // (msvcp100.dll and msvcr100.dll)
        // on Unix the gcc 4.6 runtime is required
        // fear not, for all these libraries are included in your wrpme Java API packages
        System.loadLibrary("wrpme_java_api");
    }

    public static void main(String argv[])
    {
        SWIGTYPE_p_wrp_me_session session = null;
        try
        {
            // open a wrpme session, you will have to call wrpme.close() on the session object
            session = wrpme.open();

            System.out.println("Connecting to wrpme...");

            // you are not yet connected to the wrpme server, wrpme.open() only initializes the internal
            // structures and object
            // to connect to a wrpme server, you need to specify it's address (IP or name) and it's port
            // by default wrpme listens on the port 5909
            wrp_me_error_t r = wrpme.connect(session, "127.0.0.1", 5909);

            String keyname = "my_key";

            // if the connection is successful it will return error_ok
            // this is true for all methods, success is error_ok, other values indicate an error
            if (r != wrp_me_error_t.error_ok) {
                System.err.println("An error occured: " + r);
            }

            System.out.println("Cleaning up entry...");

            // we start by making sure our entries does not exist
            // this is done with the delete method
            // this is to make sure the rest of this example will work properly
            r = wrpme.delete(session, keyname);
            if (r != wrp_me_error_t.error_ok) {
                System.err.println("Cannot delete: " + r);
            }

            // we can start with adding data, keys are strings, data are ByteBuffer
            // this is because wrpme is designed to work on large amounts of raw data
            // and using String or byte[] would result in a lot of unnecessary copies
            // and would increase the pressure on the garbage collector

            // it's less comfortable to use than a String or byte array but it really
            // makes a big difference once your data starts to get big

            // keep in mind though that wrpme is data agnostic it will store data
            // "as is", will not interpret it or modify it
            // if your data is acceded from various operating systems and/or
            // languages you will need to make sure your encoding is consistent

            System.out.println("Putting new entry...");

            String myData = "this is my data";

            // it's *VERY* important for the byte buffer to be a direct buffer
            // otherwise the JNI will not be able to access it
            java.nio.ByteBuffer bb = java.nio.ByteBuffer.allocateDirect(1024);
            bb.put(myData.getBytes());
            bb.flip();

            r = wrpme.put(session, keyname, bb, bb.limit());
            if (r != wrp_me_error_t.error_ok) {
                System.err.println("Cannot add: " + r);
            }

            // put will fail if you specify an existing key. This is by design.
            // this way you can make sure an entry is not accidentally updated
            // this call will return error_alias_already_exists
            System.out.println("Trying to put entry again...");

            String myNewData = "this is my new data";
            bb.clear();
            bb.put(myNewData.getBytes());
            bb.flip();

            r = wrpme.put(session, keyname, bb, bb.limit());
            if (r != wrp_me_error_t.error_ok) {
                System.err.println("Cannot add: " + r);
            }

            // if you want to change the data, you need to use update
            // note that you can use update to create entries as well
            System.out.println("Updating entry...");

            r = wrpme.update(session, keyname, bb, bb.limit());
            if (r != wrp_me_error_t.error_ok) {
                System.err.println("Cannot update: " + r);
            }

            System.out.println("Getting entry...");

            // most of the time you will want to read from the server rather than
            // adding to it, this is done through the use of the get method
            // see how the memory is managed on the Java side through the use of
            // ByteBuffer, this helps avoiding a lot of potential memory leaks
            // should the allocation occur in the JNI world

            // the buffer has to be large enough to hold the data
            // in this example if we allocate 1024 bytes we'll have more than enough
            // if the buffer isn't large enough wrpme will return
            java.nio.ByteBuffer content = java.nio.ByteBuffer.allocateDirect(1024);

            // but what if you don't know the size?
            // you can use the method wrpme.get_size() to know the current size of
            // an entry, a value of zero indicate the entry doesn't exist
            // in our example we would write:
            // long contentLength = wrpme.get_size(session, keyname);

            // get will nevertheless return the content length
            // this enables you to use buffer larger than the actual data
            // the content length is a first element in a 1 element array

            int [] contentLength = { 0 };

            r = wrpme.get(session, keyname, content, contentLength);
            if ((r != wrp_me_error_t.error_ok) && (contentLength[0] > 0)) {
                System.err.println("Cannot get: " + r + "(size = " + contentLength[0] + ")");
            } else {
                System.out.println("Content length: " + contentLength[0]);
                byte [] localBuf = new byte[contentLength[0]];

                content.get(localBuf, 0, contentLength[0]);

                System.out.println("Content of " + keyname + ": " + new String(localBuf));
            }

            System.out.println("Deleting entry...");

            // we remove the entry before exiting
            r = wrpme.delete(session, keyname);
            if (r != wrp_me_error_t.error_ok) {
                System.err.println("Cannot delete: " + r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // close will release all allocated data  (client side) and reset all connections
            // of course all the data you added on the server will stay!
            // also, all your bytebuffers will stay alive as they are managed by Java and unrelated to wrpme
            if (session != null) {
                wrpme.close(session);
            }
        }
    }
}
