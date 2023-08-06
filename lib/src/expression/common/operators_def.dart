const op$currentDate = r'$currentDate';
const opDateTypeDoc = {r'$type': 'date'};
const opTimeStampeTypeDoc = {r'$type': 'timestamp'};

const op$inc = r'$inc';
const op$min = r'$min';
const op$max = r'$max';
const op$mul = r'$mul';
const op$rename = r'$rename';
const op$set = r'$set';
const op$setOnInsert = r'$setOnInsert';
const op$unset = r'$unset';

// *************  Comparison
const op$eq = r'$eq';
const op$gt = r'$gt';
const op$gte = r'$gte';
const op$lt = r'$lt';
const op$lte = r'$lte';
const op$ne = r'$ne';
const op$in = r'$in';
const op$nin = r'$nin';

// ************* Geo Spatial
const op$within = r'$within';
const op$box = r'$box';
const op$near = r'$near';
const op$maxDistance = r'$maxDistance';
const op$minDistance = r'$minDistance';
const op$geoWithin = r'$geoWithin';
const op$nearSphere = r'$nearSphere';
const op$geoIntersects = r'$geoIntersects';

// ************* Element
const op$exists = r'$exists';
const op$type = r'$type';

// ************* Evaluation
const op$expr = r'$expr';
const op$mod = r'$mod';
const op$regex = r'$regex';
const op$options = r'$options';
const op$where = r'$where';
const op$jsonSchema = r'$jsonSchema';
const op$text = r'$text';
const op$search = r'$search';
const op$language = r'$language';
const op$caseSensitive = r'$caseSensitive';
const op$diacriticSensitive = r'$diacriticSensitive';

// ************* Logical
const op$and = r'$and';
const op$not = r'$not';
const op$or = r'$or';
const op$nor = r'$nor';

// ************* array Query
const op$all = r'$all';
const op$size = r'$size';

// ************* miscellaneous
const op$comment = r'$comment';

const op$addToSet = r'$addToSet';
const op$pop = r'$pop';
const op$pull = r'$pull';
const op$push = r'$push';
const op$pullAll = r'$pullAll';

const op$each = r'$each';
const op$position = r'$position';
const op$slice = r'$slice';
const op$sort = r'$sort';
const op$meta = r'$meta';
const op$elemMatch = r'$elemMatch';

const op$Bit = r'$bit';
const opBitAnd = 'and';
const opBitOr = 'or';
const opBitXor = 'xor';
