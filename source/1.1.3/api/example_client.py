import qdb

# Assuming we have a quasardb server running on dataserver.mydomain:3001
# Note this will throw an exception if the quasardb cluster is not available.
cl = qdb.Client(qdb.RemoteNode('dataserver.mydomain', 3001))

# We want to silently create or update the object
# depending on the existence of the key in the cluster.
def save(key, obj):
    cl.update(key, obj)

# We want to simply return None if the key is not found in the cluster.
def load(key):
    try:
        return cl.get(key)
    except qdb.QuasardbException:
        return None
