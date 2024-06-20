# Reading
- It’s easy to read data because clients can connect to any node in the cluster to perform reads, without having to know whether a particular node acts as a replica for that data. If a client connects to a node that doesn’t have the data it’s trying to read, the node it’s connected to will act as a coordinator node to read the data
from a node that does have it, identified by token ranges
- The read path begins when a client initiates a read query to the coordinator node
- a remote coordinator is selected per data center for any read queries that involve multiple data centers.
- If the coordinator is not itself a replica, the coordinator then sends aread request to the fastest replica, as determined by the dynamic snitch.
- The coordinator node also sends a digest request to the other replicas
- A digest request is similar to a standard read request, except the replicas return a digest, or hash, of the requested data.
- The coordinator calculates the digest hash for data returned from the fastest replica and compares it to the digests returned from the other replicas.
- If the digests are consistent, and the desired consistency level has been met, then the data from the fastest replica can be returned
- If the digests are not consistent, then the coordinator must perform a read repair
- When the replica node receives the read request, it first checks the row cache. If the row cache contains the data, it can be returned immediately
- If the data is not in the row cache, the replica node searches for the data in memtables and SSTables. There is only a single memtable for a given table, so that part of the search is straightforward
- there are potentially many physical SSTables for a single Cassandra table, each of which may contain a portion of the requested data.
- The first step in searching SSTables on disk is to use a Bloom filter to determine whether the requested partition does not exist in a given SSTable, which would make it unnecessary to search that SSTable
