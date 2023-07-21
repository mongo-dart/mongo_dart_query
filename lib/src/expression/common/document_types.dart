// TODO share with mongo_dart. Common package?

typedef MongoDocument = Map<String, dynamic>;
MongoDocument get emptyMongoDocument => <String, dynamic>{};
typedef QueryFilter = Map<String, dynamic>;
QueryFilter get emptyQueryFilter => <String, dynamic>{};
typedef UpdateDocument = Map<String, MongoDocument>;
UpdateDocument get emptyUpdateDocument => <String, MongoDocument>{};
typedef IndexDocument = Map<String, Object>;
typedef ProjectionDocument = Map<String, Object>;
typedef ArrayFilter = Map<String, dynamic>;
