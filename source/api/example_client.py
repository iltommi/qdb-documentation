import qdb

# Assuming we have a quasardb server running on dataserver.mydomain:3001
# Note this will throw an exception if the quasardb cluster is not available.
cl = qdb.Cluster("qdb://dataserver.mydomain:3001")

# We want to silently create or update the object
# depending on the existence of the key in the cluster.
def save(key, obj):
    b = cl.blob(key)
    b.update(obj)

# We want to simply return None if the key is not found in the cluster.
def load(key):
    try:
        b = cl.blob(key)
        return b.get(key)
    except qdb.QuasardbException:
        return None
