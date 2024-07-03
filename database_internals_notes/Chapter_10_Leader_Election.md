Synchronization can be quite costly: if each algorithm step involves contacting each other participant, we can end up with a significant communication overhead. This is particularly true in large and geographically distributed networks. To reduce synchronization overhead and the number of message round-trips required to reach a decision, some algorithms rely on the existence of the leader (sometimes called coordinator) process, responsible for executing or coordinating steps of a distributed algorithm.
- Any process can take over the leadership role.
- Usually, the process remains a leader until it crashes and Election is triggered when the system initializes
- After the crash, any other process can start a new election round, assume leadership
- The liveness of the election algorithm guarantees that most of the time there will be a leader, and the election will eventually complete there may be at most one leader at a time, and completely eliminate the possibility of a split brain situation (when two leaders serving the same purpose are elected but unaware of each other).
- Election has to be deterministic: exactly one leader has to emerge from the process

One of the potential problems in systems with a notion of leadership is that the leader can become a bottleneck. To overcome that, many systems partition data in non-intersecting independent replica sets (see “Database Partitioning”). Instead of having a single system-wide leader, each replica set has its own leader
