# Lock Based Concurrency Control
## Simple Shared/Exclusive Lock Protocol
In DBMS Lock based Protocols, there are two modes for locking and unlocking data items Shared Lock (lock-S) and Exclusive Lock (lock-X).
### Shared Locks
- Shared Locks, which are often denoted as lock-S(), is defined as locks that provide Read-Only access to the information associated with them. Whenever a shared lock is used on a database, it can be read by several users, but these users who are reading the information or the data items will not have permission to edit it or make any changes to the data items.  
- To put it another way, we can say that shared locks don't provide access to write. Because numerous users can read the data items simultaneously, multiple shared locks can be installed on them at the same time, but the data item must not have any other locks connected with it.
- A shared lock, also known as a read lock, is solely used to read data objects. Read integrity is supported via shared locks.
- Shared locks can also be used to prevent records from being updated.
- S-lock is requested via the Lock-S instruction.
### Exclusive Lock
- Exclusive Lock allows the data item to be read as well as written. This is a one-time use mode that can't be utilized on the exact data item twice. To obtain X-lock, the user needs to make use of the lock-x instruction. After finishing the 'write' step, transactions can unlock the data item.
- By imposing an X lock on a transaction that needs to update a person's account balance, for example, you can allow it to proceed. As a result of the exclusive lock, the second transaction is unable to read or write.
- The other name for an exclusive lock is write lock.
- At any given time, the exclusive locks can only be owned by one transaction.
### Problems
1. It may not be sufficient to produce serializability
2. May not be free from irrecoverability
3. May not be free from deadlock
4. May not be free from starvation
   
## Two Phase Lock Protocol
- __Growing Phase:__  Locks are acquired & no locks are released
- __Shrinking Phase:__ Locks are released & no locks are acquired
- __Lock Point:__ Time at which shrinking phase started

### Advantage/Problems
1. It always ensures serializable
2. May not be free from irrecoverability
3. Not be free from deadlock
4. Not be free from starvation
5. Not be free from cascading rollback

### Strict Two Phase Lock Protocol
It will have all the property of basic 2PL.Additionally all the exclusive locks should hold untill commit/abort.It removes cascading rollback,irrecoverability issues
### Rigorous Two Phase Lock Protocol
It will have all the property of basic 2PL.Additionally all the shared & exclusive locks should hold untill commit/abort.It removes cascading rollback,irrecoverability issues
  
# Optimistic Concurrency Control
Optimistic concurrency control assumes that transaction conflicts occur rarely and, instead of using locks and blocking transaction execution, we can validate transactions to prevent read/write conflicts with concurrently executing transactions and ensure serializability before committing their results. Generally, transaction execution is split into three phases  
### Read phase
The transaction executes its steps in its own private context, without making any of the changes visible to other transactions. After this step, all transaction dependencies (read set) are known, as well as the side effects the transaction produces (write set).
### Validation phase
Read and write sets of concurrent transactions are checked for the presence of possible conflicts between their operations that might violate serializability. If some of the data the transaction was reading is now out-of date, or it would overwrite some of the values written by transactions that committed during its read phase, its private context is cleared and the read phase is restarted. In other words, the validation phase determines whether or not committing the transaction preserves ACID properties.
### Write phase
If the validation phase hasn’t determined any conflicts, the transaction can commit its write set from the private context to the database state else can abort the transaction.

# Timestamp Based Concurrency Control
- It is used to order the transaction based on their timestamp.
- Order of transaction execution is ascending with respect to timestamp.
- Priority of older transaction is higher so it gets executed first.
- To determine the timestamp of transaction it uses system_time, logical counter or unique values.
- It maintains a last read,write  timestamp of operation performed on data.

__TS(Ti)__ - Timestamp of transaction Ti  
__R_TS(X)__ - Timestamp of last read on data x  
__W_TS(X)__ - Timestamp of last write on data x  

### Read Condition:
If W_TS(X)>TS(Ti) Operation rejected & Rollback else read operation is allowed,set R_TS(X)= LAST(TS(Ti),R_TS(X))
### Write Condition:
If ( W_TS(X)>TS(Ti) or R_TS(X)>TS(Ti) ) Operation rejected & rollback else write operation is allowed,set W_TS(X)= LAST(TS(Ti))
