# Inserts a document or documents into a collection
```commandline
db.collection.insert(
   <document or array of documents>,
   {
      writeConcern: <document>,
      ordered: <boolean>
   }
)
```
# Inserts a document into a collection
```
db.collection.insertOne(
    <document>,
    {
      writeConcern: <document>
    }
)
```
# Inserts a document or documents into a collection
```
db.collection.insertMany(
   [ <document 1> , <document 2>, ... ],
   {
      writeConcern: <document>,
      ordered: <boolean>
   }
)
```
## Params
__document:__ An array of documents to insert into the collection.  
__writeConcern :__ Optional. A document expressing the write concern. Omit to use the default write concern.
                             Do not explicitly set the write concern for the operation if run in a transaction.  
                             To use write concern with transactions, see Transactions and Write Concern.  
__ordered:__ Optional. A boolean specifying whether the mongod instance should perform an ordered or unordered insert. Defaults to true.