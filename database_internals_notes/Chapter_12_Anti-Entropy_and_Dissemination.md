The coordinator will do its best and deliver the messages to all available participants, and then anti-entropy mechanisms will bring nodes back in sync in case there were any failures. This way, the responsibility for delivering
messages is shared by all nodes in the system, and is split into two steps: 
- Primary delivery
- Periodic sync
Anti-entropy is usually used to bring the nodes back up-to-date in case the primary delivery mechanism has failed.To keep nodes in sync, anti-entropy triggers a background or a foreground process that compares and reconciles missing or conflicting records. Background
anti-entropy processes use auxiliary structures such as Merkle trees and update logs to identify divergence. Foreground anti-entropy processes piggyback read or write requests: hinted handoff, read repairs, etc

# Read Repair
- It is easiest to detect divergence between the replicas during the read, since at that point we can contact replicas, request the queried state from each one of them, and see whether or not their responses match. 
- Note that in this case we do not query an entire dataset stored on each replica, and we limit our goal to just the data that was requested by the client.

The coordinator performs a distributed read, optimistically assuming that
replicas are in sync and have the same information available. If replicas send different responses, the coordinator sends missing updates to the replicas where they’re missing This mechanism is called read repair
- Some Dynamo-style databases choose to lift the requirement of contacting all replicas and use tunable consistency levels instead.
- To return consistent results, we do not have to contact and repair all the replicas, but only the number of nodes that satisfies the consistency level
- Read repair can be implemented as a blocking or asynchronous operation.
- During blocking read repair, the original client request has to wait until the coordinator “repairs” the replicas
- Asynchronous read repair simply schedules a task that can be executed after results are returned to the user
- Blocking read repair ensures read monotonicity for quorum reads: as soon as the client reads a specific value, subsequent reads return the value at least as recent as the one it has seen, since replica states were repaired
- If we’re not using quorums for reads, we lose this monotonicity guarantee as data might have not been propagated to the target node by the time of a subsequent read
- At the same time, blocking read repair sacrifices availability, since repairs should be acknowledged by the target replicas and the read cannot return until they respond
- Read repair assumes that replicas are mostly in sync and we do not expect every request to fall back to a blocking repair. Because of the read monotonicity of blocking repairs, we can also expect subsequent requests to return the same consistent results, as long as there was no write operation that has completed in the interim

# Digest Reads
- Instead of issuing a full read request to each node, the coordinator can issue only one full read request and send only digest requests to the other replicas
- A digest request reads the replica-local data and, instead of returning a full snapshot of the requested data, it computes a hash of this response
- Now, the coordinator can compute a hash of the full read and compare it to digests from all other nodes
- If all the digests match, it can be confident that the replicas are in sync
- In case digests do not match, the coordinator does not know which replicas are ahead, and which ones are behind
- To bring lagging replicas back in sync with the rest of the nodes, the coordinator has to issue full reads to any replicas that responded with different digests, compare their responses, reconcile the data, and send updates to the lagging replicas.
- Digests are usually computed using a noncryptographic hash function, such as MD5, since it has to be computed quickly to make the “happy path” performant

# Hinted Handoff
- Another anti-entropy approach is called hinted handoff , a write-side repair mechanism.If the target node fails to acknowledge the write, the write coordinator or one of the replicas stores a special record, called a hint, which is replayed to the target node as soon as it comes back up  
- In Apache Cassandra, unless the ANY consistency level is in use, hinted writes aren’t counted toward the replication factor since the data in the hint log isn’t accessible for reads and is only used to help the lagging participants catch up.
- Some databases, for example Riak, use sloppy quorums together with hinted handoff. With sloppy quorums, in case of replica failures, write operations can use additional healthy nodes from the node list, and these nodes do not have to be target replicas for the executed operations.

For example, say we have a five-node cluster with nodes {A, B, C, D, E}, where {A, B, C} are replicas for the executed write operation, and node B is down. A, being the coordinator for the query, picks node D to satisfy the sloppy
quorum and maintain the desired availability and durability guarantees.  
Now, data is replicated to {A, D, C}. However, the record at D will have a hint in its metadata, since the write was originally intended for B. As soon as B recovers, D will attempt to forward a hint back to it. Once the hint is replayed on B, it can be
safely removed without reducing the total number of replicas .  
Under similar circumstances, if nodes {B, C} are briefly separated from the rest of the cluster by the network partition, and a sloppy quorum write was done against {A, D, E}, a read on {B, C}, immediately following this write, would
not observe the latest read. In other words, sloppy quorums improve availability at the cost of consistency.

# Merkle Trees
- Since read repair can only fix inconsistencies on the currently queried data, we should use different mechanisms to find and repair inconsistencies in the data that is not actively queried.
- As we already discussed, finding exactly which rows have diverged between the replicas requires exchanging and comparing the data records pairwise. This is highly impractical and expensive. Many databases employ Merkle trees to reduce the cost of reconciliation
- Merkle trees compose a compact hashed representation of the local data, building a tree of hashes. The lowest level of this hash tree is built by scanning an entire table holding data records, and computing hashes of record ranges
- Higher tree levels contain hashes of the lower-level hashes, building a hierarchical representation that allows us to quickly detect inconsistencies by comparing the hashes, following the hash tree nodes recursively to narrow down inconsistent ranges.
- This can be done by exchanging and comparing subtrees level-wise, or by exchanging and comparing entire trees
- To determine whether or not there’s an inconsistency between the two replicas, we only need to compare the root-level hashes from their Merkle trees
- By comparing hashes pairwise from top to bottom, it is possible to locate ranges holding differences between the nodes, and repair data records contained in them
- Since Merkle trees are calculated recursively from the bottom to the top, a change in data triggers recomputation of the entire subtree
![image](https://github.com/yadavraganu/databases/assets/77580939/cdc155cc-c5d4-4515-a204-260c7e82b199)
