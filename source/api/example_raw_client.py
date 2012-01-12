import uuid
import wrpme

# If the document is bigger than 10 MiB, we slice it
SIZE_LIMIT = 10 * 1024 * 1024

# Note given what we are doing here, the server should be configure with
# a limiter-max-bytes of 1 GiB at least for proper caching
cl = wrpme.RawClient('docserver.mydomain', 3002)

# We expect a readable file-like object
def upload(f):
    key = uuid.uuid4()

    # If we need to slice, suffix the entry key by the slice number
    # An empty slice marks the end of the file. 
    current_slice = f.read(SIZE_LIMIT)
    count = 0
    while len(current_slice) > 0:
        cl.put(key.hex + str(count), current_slice)
        current_slice = f.read(SIZE_LIMIT)
        count += 1
    return key

# We expect an uuid and a writable file-like object
def download(key, f):
    try:
        count = 0
        while True:
            f.write(cl.get(key.hex + str(count)))
            count += 1
    
    # If count is >0, we had at least one slice, so it is ok
    # If not, we have really not found the file.
    except wrpme.AliasNotFound:
        if not count: raise
