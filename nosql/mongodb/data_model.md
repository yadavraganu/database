MongoDB's collections, by default, do not require their documents to have the same schema
The documents in a single collection do not need to have the same set of fields and the data type for a field can differ across documents within a collection.   

To change the structure of the documents in a collection, such as add new fields, remove existing  
fields, or change the field values to a new type, update the documents to the new structure.  

The key decision in designing data models for MongoDB applications revolves around the structure of documents and  
how the application represents relationships between data. MongoDB allows related data to be embedded within a single document

## Embedded Data
Embedded documents capture relationships between data by storing related data in a single document structure.  
MongoDB documents make it possible to embed document structures in a field or array within a document.  
These denormalized data models allow applications to retrieve and manipulate related data in a single database operation.
![image](https://github.com/yadavraganu/databases/assets/77580939/92db184e-29a0-4900-b361-5b7943702876)


## References
References store the relationships between data by including links or references from one document to another. Applications  
can resolve these references to access the related data. Broadly, these are normalized data models.
![image](https://github.com/yadavraganu/databases/assets/77580939/48f34b47-2fd8-422d-bc67-b29f0f9309d2)

# Atomicity of Write Operations
## Single Document Atomicity
In MongoDB, a write operation is atomic on the level of a single document, even if the operation modifies multiple embedded documents within a single document.  
A denormalized data model with embedded data combines all related data in a single document instead of normalizing across multiple documents and collections.    
This data model facilitates atomic operations.

## Multi-Document Transactions
When a single write operation (e.g. db.collection.updateMany()) modifies multiple documents, the modification of each document is atomic, but the operation as a whole is not atomic.  
When performing multi-document write operations, whether through a single write operation or multiple write operations, other operations may interleave.  
For situations that require atomicity of reads and writes to multiple documents (in a single or multiple collections), MongoDB supports multi-document transactions
