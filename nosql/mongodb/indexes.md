## Covered Query
It is query which runs entirely usin index without having to scan any document
Criterion for a covered query :
1. Query field are part of index
2. Result fields/projection fields are part of index
3. Field does not have null value

## Text Index
1. Supports text search on string content.
2. Field can be string or array of strings.
3. Only one text index per collection  
```
Create Index 
db.collection.createIndex({ "field_name" : "text" })
db.reviews.createIndex({subject: "text",comments: "text"})
Run Query
db.collection.find({"$text":{"$search":"Test_Search"}})
```

