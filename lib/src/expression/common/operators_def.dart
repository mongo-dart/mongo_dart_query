const op$CurrentDate = r'$currentDate';
const opDateTypeDoc = {r'$type': 'date'};
const opTimeStampeTypeDoc = {r'$type': 'timestamp'};

const op$Inc = r'$inc';
const op$Min = r'$min';
const op$Max = r'$max';
const op$Mul = r'$mul';
const op$Rename = r'$rename';
const op$Set = r'$set';
const op$SetOnInsert = r'$setOnInsert';
const op$Unset = r'$unset';

// *************  Comparison
const op$Eq = r'$eq';
const op$Gt = r'$gt';
const op$Gte = r'$gte';
const op$Lt = r'$lt';
const op$Lte = r'$lte';
const op$Ne = r'$ne';
const op$In = r'$in';
const op$Nin = r'$nin';
// ************* Text
const op$Text = r'$text';
const op$Search = r'$search';
const op$Language = r'$language';
const op$CaseSensitive = r'$caseSensitive';
const op$DiacriticSensitive = r'$diacriticSensitive';

// ************* Geo Spatial
const op$Within = r'$within';
const op$Box = r'$box';
const op$Near = r'$near';
const op$MaxDistance = r'$maxDistance';
const op$MinDistance = r'$minDistance';
const op$GeoWithin = r'$geoWithin';
const op$NearSphere = r'$nearSphere';
const op$GeoIntersects = r'$geoIntersects';

// ************* Logical
const op$And = r'$and';
const op$Not = r'$not';
const op$Or = r'$or';
const op$Nor = r'$nor';

const op$AddToSet = r'$addToSet';
const op$Pop = r'$pop';
const op$Pull = r'$pull';
const op$Push = r'$push';
const op$PullAll = r'$pullAll';

const op$Each = r'$each';
const op$Position = r'$position';
const op$Slice = r'$slice';
const op$Sort = r'$sort';

const op$Bit = r'$bit';
const opBitAnd = 'and';
const opBitOr = 'or';
const opBitXor = 'xor';
