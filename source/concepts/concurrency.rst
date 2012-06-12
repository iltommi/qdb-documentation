Concurrency
**************************************************


Principles
=======================================

Server
-------

The server can serve as many conccurent requests as the operating system and the underlying hardware permit. It is heavily multithreaded and thrives on multiprocessor hardware.

The server will make sure that requests do not conflict with each other. It will spread the load on all the processing power available, if need be.

The server automatically adjusts its multithreading configuration to the underlying hardware. No user intervention is required. Running several servers instances on the same node is counter-productive.

Client
-------

All API are thread safe. All calls are synchronous unless otherwise noted.

When the client receives a reply from the server, the request is guaranteed to have been carried out by the server, as specified by the answer.

The client takes care of locating the proper node for the request. The client will either find the proper node or fail (this may happen if the ring is unstable).


Guarantees
=======================================

     * All requests, unless otherwise noted, are atomic
     * All requests, unless otherwise noted, are consistent
     * All requests, unless otherwise noted, are isolated
     * All requests, unless otherwise noted, are durable (see :ref:`fault-tolerance`)
     * Once the server replies, it means the request has been fully carried on
     * Synchronous clients requests are executed in order. However multiple requests coming from mutliple clients are executed in an arbitrary order (see :ref:`conflicts-resolution`)

The notable exception to the ACID guarantees are streaming operations (see :doc:`streaming`)

.. _conflicts-resolution:
Conflicts resolution
=====================================================

When conflict may occur
-------------------------

When executing a series of requests, each request is ACID (Atomic, Consistent, Isolated and Durable) and the requests will be executed in the given order.

For example, if a client adds an entry and later gets it, the get is guaranteed to succeed if the add was successful (unless an external error occurs such as a low memory condition, a hardware or power failure, an operating system fault, etc.).

For example:

    * Client A adds an entry "car" and sets it to "roadster"
    * Client A gets the entry "car" and obtains the value "roadster"

However, in a multiclient context, conflicts may arise. What happens if a Client B updates the entry before the Client A is finished?

    * Client A adds an entry "car" and sets it to "roadster"
    * Client B updates the entry "car" to "sedan"
    * Client A gets the entry "car" and obtains the value "sedan"

From the point of view of wrpme, everything is perfectly valid and coherent, but from the point of view of the client A, something wrong happened!

How to use the API to avoid conflicts
--------------------------------------

Conflicts arise when the **usage is not carefully thought out**. It's a client's design problem, not a server problem.

On one hand it does not make sense to have clients simultaneously update the same entry an expect the value to be coherent from the point of view of a single client. wrpme could leave it as is and require the client to have a coherent usage scenario.

On the other hand it's a shame the clients cannot rely on the power of wrpme to at least detect something is wrong.

That's why our API ensures clients avoid or at the very least detect conflicts and have a consistent behaviour (see :doc:`../api/index`).

The above can be avoided thanks to the way put works. Put fails if the entry already exist, therefore, our example becomes:

    * Client A adds an entry "car" and sets it to "roadster"
    * Client B puts the entry "car" and fails because the entry already exists
    * Client A gets the entry "car" and obtains the value "sedan"

Since update always succeed, it is however possible to share a single value amongst different clients with the usage of the update command:

    * Client A updates the entry "stock3" to "503.5"
    * Client B updates the entry "stock3" to "504.5"
    * Client A gets the entry "stock3" and gets the newest value "504.5"

As you can see what was previously considered a conflict is now the expected behaviour.

It is possible to create more complex scenarii thanks to the get_update and compare_and_swap commands. get_update atomically gets the previous value of an entry and updates it to a new one. compare_and_swap updates the value if it matches and return the old/unchanged value.

Rule of thumb:

    * DO NOT mix put and update calls

Updating multiple entries at a time
-------------------------------------

We've seen a trivial conflict case, but what about this one:

    * Client A updates an entry "car" and sets it to "roadster"
    * Client A updates an entry "motorbike" and sets it to "roadster"
    * Client B gets "car" and "motorbike" and checks that they match

As you can see, if client B makes the query too early, it does not match. There are things you can do with get_update and compare_and_swap, but it can quickly become intricate and unmaintenable.

The one thing to understand is that it's a design usage problem on the client side.

    * Is it a problem for Client B to have a mismatch? Client B may try again later.
    * If you always need to update several entries and have them consistent, why have several entries?
    * Shouldn't be Client A and B be synchronized? That is, shouldn't Client B query the entry only once it knows they have been updated?

As you can see, a conflict is a question of context and usage.

The best way to avoid conflicts: plan out
------------------------------------------------------

wrpme provides several mechanisms to allow clients to synchronize themselves and avoid conflicts. However, the most important step to ensure proper operation is to plan out. What is a conflict? Is it a problem? Only a thorough planification can tell.

Things to consider:

    * Clients are generally heterogenous. Some clients update content while other only consume content. It is more simple to design each client according to its purpose rather than one "fits all" client.
    * There is always an update delay, whatever system you're using. The question is, what delay can your business case tolerate? For example a high frequency trading automaton and a reservation system have different requirements.
    * The problem is never the conflict in itself. The problem is operating without realizing that there was a conflict in the first place.
    * wrpme provides way to synchronize clients. For example, put fails if the entry already exists and update always succeed.



