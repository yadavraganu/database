Transactional database systems allow different isolation levels. An isolation level specifies how and when parts of the transaction can and should become visible to other transactions. In other words, isolation levels describe the degree to which transactions are isolated from other concurrently executing transactions, and what kinds of anomalies can be encountered during execution.  
Achieving isolation comes at a cost: to prevent incomplete or temporary writes from propagating over transaction boundaries, we need additional coordination and synchronization, which negatively impacts the performance.
# Isolation Levels
### Read Uncommitted
The lowest (weakest) isolation level is read uncommitted. Under this isolation level, the transactional system allows one transaction to observe/read uncommitted changes of other concurrent transactions. In other words, dirty reads are allowed.

### Read Committed
This make sures that any read performed by the specific transaction can only read already committed changes. However, it is not guaranteed that if the transaction attempts to read the same data record once again at a later stage, it will see the same value. If there
was a committed modification between two reads, two queries in the same transaction would yield different results. In other words, dirty reads are not permitted, but phantom and nonrepeatable reads are.

### Repeatable Read
If we further disallow nonrepeatable reads in above discussed isolation level, we get a repeatable read isolation level.

### Serializability
The strongest isolation level is serializability. It guarantees that transaction outcomes will appear in some order as if transactions were executed serially (i.e., without overlapping in time).Disallowing concurrent execution would have a substantial negative impact on
the database performance.   
Transactions can get reordered, as long as their internal invariants hold and can be executed concurrently, but their outcomes have to appear in some serial order.Transactions that do not have dependencies can be executed in any order since their results are fully independent.
