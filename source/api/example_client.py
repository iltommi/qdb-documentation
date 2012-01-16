import wrpme

# Assuming we have a wrpme server running on dataserver.mydomain:3001
# Note this will throw an exception if the wrpme hive is not available.
cl = wrpme.Client('dataserver.mydomain', 3001)

# We want to silently create or update the object
# depending on the existence of the key in the hive.
def save(key, obj):
    cl.update(key, obj)

# We want to simply return None if the key is not found in the hive.
def load(key):
    try:
        return cl.get(key)
    except wrpme.AliasNotFound:
        return None
