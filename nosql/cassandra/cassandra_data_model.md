# Clusters
The Cassandra database is specifically designed to be distributed over several machines operating together that appear as a single instance to the end user. So the outermost structure in Cassandra is the cluster, sometimes called the ring, because Cassandra assigns data to nodes in the cluster by arranging them in a ring.

# Keyspaces
A cluster is a container for keyspaces. A keyspace is the outermost container for data in Cassandra, corresponding closely to a database in the relational model. In the same way that a database is a container for tables in the relational model, a keyspace is a container for tables in the Cassandra data model. Like a relational database, a keyspace has a name and a set of attributes that define keyspace-wide behavior such as replication.

# Tables
A table is a container for an ordered collection of rows, each of which is itself an ordered collection of columns. Rows are organized in partitions and assigned to nodes in a Cassandra cluster according to the column(s) designated as the partition key. The ordering of data within a partition is determined by the clustering columns. When you write data to a table in Cassandra, you specify values for one or more columns. That collection of values is called a row. You must specify a value for each of the columns contained in the primary key as those columns taken together will uniquely identify the row.
While you do need to provide a value for each primary key column when you add a new row to the table, you are not required to provide values for nonprimary key columns.

# Columns
A column is the most basic unit of data structure in the Cassandra data model. So far you’ve seen that a column contains a name and a value.You constrain each of the values to be of a particular type when you define the column.Let’s take a look into some other
attributes of a column that is: timestamps and time to live. These attributes are key to understanding how Cassandra uses time to keep data current.
### TIMESTAMPS
Each time you write data into Cassandra, a timestamp, in microseconds,is generated for each column value that is inserted or updated.Internally, Cassandra uses these timestamps for resolving any conflicting changes that are made to the same value, in what is frequently referred to as a last write wins approach
### TIME TO LIVE (TTL)
One very powerful feature that Cassandra provides is the ability to expire data that is no longer needed. This expiration is very flexible and works at the level of individual column values. The time to live (TTL) is a value that Cassandra stores for each column value to indicate how long to keep the value.
