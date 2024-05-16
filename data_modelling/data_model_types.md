# Data Model Types
As you move through your data modeling process, you’ll develop three types of models–conceptual, logical, and physical. Ideally,  
you’ll involve business users as well as members of your data management team. Each model builds on the previous one, becoming more complex and specific as you progress.

- A __conceptual data model__ is a simple, high-level representation of the data in your organization defined according to business requirements.
  It focuses on business-oriented attributes, entries, and relationships, independent of any specific technology or database management system.
  It caters to a specific business audience and defines the key concepts and relationships between the elements in a domain.  
  A conceptual data model identifies the highest-level relationships between the different entities. Features of conceptual data model include:
  
  1. Includes the important entities and the relationships among them.
  2. No attribute is specified.
  3. No primary key is specified.
  4. The figure below is an example of a conceptual data model.  
     ![image](https://github.com/yadavraganu/data-modelling/assets/77580939/8362b6e2-297c-4328-8795-3336a2f86705)


- A __logical data model__ is a more complex representation of the data structures and relationships within a system or your organization.
  It defines the entities, attributes, and relationships that make up the data, but does not specify the physical storage or implementation details.
  Logical models are used to communicate the conceptual design of a system to stakeholders and to guide the development of the physical data model and database.
  In agile DevOps or DataOps practices, this phase is sometimes skipped.
  A logical data model describes the data in as much detail as possible, without regard to how they will be physical implemented in the database.
  Features of a logical data model include:
  
  1. Includes all entities and relationships among them.
  2. All attributes for each entity are specified.
  3. The primary key for each entity is specified.
  4. Foreign keys (keys identifying the relationship between different entities) are specified. 
  5. Normalization occurs at this level.
     
  The steps for designing the logical data model are as follows:

  1. Specify primary keys for all entities.
  2. Find the relationships between different entities.
  3. Find all attributes for each entity.
  4. Resolve many-to-many relationships.
  5. Normalization.  
     ![image](https://github.com/yadavraganu/data-modelling/assets/77580939/47677594-4609-4ad8-8563-e6e5b1f2fa3a)


- A __physical data model__ is a detailed representation of a database design that includes information about the specific data types, sizes, and constraints of each field,
  as well as the relationships between tables and other database objects. It also includes information about the physical storage of your data, such as the location of
  files and the use of indexes and other performance optimization techniques. The physical model is used to guide the actual implementation of a database and
  is therefore specific to the DBMS or application software you implement.
  Physical data model represents how the model will be built in the database. A physical database model shows all table structures, including column name, column data type,
  column constraints, primary key, foreign key, and relationships between tables. Features of a physical data model include:
   
  1. Specification all tables and columns.
  2. Foreign keys are used to identify relationships between tables.
  3. Denormalization may occur based on user requirements.
  4. Physical considerations may cause the physical data model to be quite different from the logical data model.
  5. Physical data model will be different for different RDBMS. For example, data type for a column may be different between MySQL and SQL Server.
     
  The steps for physical data model design are as follows:
  
  1. Convert entities into tables.
  2. Convert relationships into foreign keys.
  3. Convert attributes into columns.
  4. Modify the physical data model based on physical constraints / requirements.
     ![image](https://github.com/yadavraganu/data-modelling/assets/77580939/33325781-882a-420c-9803-ce51ffd47660)

     
