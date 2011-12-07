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
 
import java.util.HashMap;
import java.util.Map;

import com.b14.wrpme.*; 

class WrpmeExample
{
    
    public static void main(String argv[])
    {
        // You need to configure your wrpme instance thanks to a map
        // it will tell the client API where the daemon is
        Map<String,String> config = new HashMap<String,String>();
        String cacheName = "test";
        config.put("name", cacheName);
        config.put("host", "127.0.0.1");
        config.put("port", "5909");


        // the key has to be a string
        String keyName = "myKey";
        // note that the value can be any Java object
        String keyValue = "myValue";  
                  
        try 
        {
            System.out.println("Creating wrpme instance...");
            WrpmeManager.getInstance().createCache(config);
            Wrpme cache = WrpmeManager.getInstance().getCache(cacheName);
            if (cache != null)
            {
                System.out.println("Adding (" + keyName + ", " + keyValue + ")");
                cache.put(keyName, keyValue);
                
                // Check if a value has been stored at key
                System.out.println("Getting value for key " + keyName + "...");

                String value = cache.get(keyName);

                System.out.println("Result: " + value);

                System.out.println("Removing entry for " + keyName);
                cache.delete(keyName);               
            }
            else
            {
                System.err.println("Could not create wrpme!");
            }

        } catch (Exception e) {
            System.err.println("Wrpme error for [" + keyName + "] ->" + e.getMessage());
            e.printStackTrace();
        } finally {
            // Clean up stored value
            try {
                Wrpme cache = WrpmeManager.getInstance().getCache(cacheName);
                if (cache != null)
                {
                    cache.close();
                }
            } catch (WrpmeException e) {
                System.err.println("Wrpme error: " + e.getMessage());
            }
        } 
    }


}
