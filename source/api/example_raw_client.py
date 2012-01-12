import uuid
import wrpme

# If the document is bigger than 10 MiB, we slice it
SIZE_LIMIT = 10 * 1024 * 1024

# Note given what we are doing here, the server should be configure with
# a limiter-max-bytes of 1 GiB at least for proper caching
cl = wrpme.RawClient('docserver.mydomain', 3002)

# We expect a readable file-like object with size() and read(size) methods
def upload(f):
    key = uuid.uuid4()
    
    # If we need to slice, suffix the entry key and 
    # push the slices count, then push the slices themselves. 
    # Note in this case we do not push the actual key we return
    # so we can distinguish sliced files from the others.
    if f.size() > SIZE_LIMIT:
        div = divmod(f.size(), SIZE_LIMIT)
        slices_count = div[0] + 1 if div[1] else div[0]

        # wrpme will ensure a good distribution
        # of the slices even if their names are close.
        cl.put(key.hex + '-slice_count', str(slices_count))
        for i in range(slices_count):
            cl.put(key.hex + str(i), f.read(SIZE_LIMIT))
    
    # else just put the file directly.
    else:
        cl.put(key.hex, f.read(SIZE_LIMIT))
        
    return key

# We expect an uuid and a writable file-like object with write() method
def download(key, f):
    # We optimze for little files, 
    # try to fetch them directly with no overhead
    try:
        f.write(cl.get(key.hex))
    
    # If this fails, maybe we have slices
    except wrpme.AliasNotFound:
        slices_count = int(cl.get(key.hex + '-slice_count'))
        for i in range(slices_count):
            f.write(cl.get(key.hex) + str(i))
