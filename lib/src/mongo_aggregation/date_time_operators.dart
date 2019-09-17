import 'package:meta/meta.dart';

import 'aggregation_base.dart';

/// `$dateFromParts`
class DateFromParts extends Operator {
  /// Creates `$dateFromParts` operator expression
  ///
  /// Constructs and returns a Date object given the date’s constituent
  /// properties.
  DateFromParts(
      {@required year, month, day, hour, minute, second, millisecond, timezone})
      : super(
            'dateFromParts',
            AEObject({
              'year': year,
              'month': month,
              'day': day,
              'hour': hour,
              'minute': minute,
              'second': second,
              'millisecond': millisecond,
              'timezone': timezone
            }));
}

/// ISO date from parts
///
/// Variant of `$dateFromParts` operator
class IsoDateFromParts extends Operator {
  /// Creates `$dateFromParts` operator expression
  ///
  /// Uses ISO Week Date fields to construct Date
  IsoDateFromParts(
      {@required year, week, day, hour, minute, second, millisecond, timezone})
      : super(
            'dateFromParts',
            AEObject({
              'isoWeekYear': year,
              'isoWeek': week,
              'isoDayOfWeek': day,
              'hour': hour,
              'minute': minute,
              'second': second,
              'millisecond': millisecond,
              'timezone': timezone
            }));
}

/// `$dateFromString` operator
class DateFromString extends Operator {
  /// Creates `$dateFromString` operator expression
  ///
  /// Converts a date/time string to a date object.
  ///
  /// * [dateString] - The date/time string to convert to a date object.
  /// * [format] - Optional. The date format specification of the [dateString].
  /// The format can be any expression that evaluates to a string literal,
  /// containing 0 or more format specifiers.
  /// * {timezone} - Optional. The time zone to use to format the date.
  /// * [onError] - Optional. If $dateFromString encounters an error while
  /// parsing the given dateString, it outputs the result value of the provided
  /// [onError] expression. This result value can be of any type. If you do not
  /// specify [onError], `$dateFromString` throws an error if it cannot parse
  /// [dateString].
  /// * [onNull] - Optional. If the [dateString] provided to `$dateFromString` is
  /// `null` or missing, it outputs the result value of the provided [onNull]
  /// expression. This result value can be of any type. If you do not specify
  /// [onNull] and dateString is null or missing, then $dateFromString outputs null.
  DateFromString({@required dateString, format, timezone, onError, onNull})
      : super(
            'dateFromString',
            AEObject({
              'dateString': dateString,
              'format': format,
              'timezone': timezone,
              'onError': onError,
              'onNull': onNull
            }));
}

/// `$dateToParts` operator
class DateToParts extends Operator {
  /// Creates `$dateToParts` operator expression
  ///
  /// Returns a document that contains the constituent parts of a given BSON Date
  /// value as individual properties. The properties returned are year, month,
  /// day, hour, minute, second and millisecond. You can set the iso8601 property
  /// to true to return the parts representing an ISO week date instead. This will
  /// return a document where the properties are isoWeekYear, isoWeek,
  /// isoDayOfWeek, hour, minute, second and millisecond.
  DateToParts(date, {timezone, bool iso8601})
      : super('dateToParts',
            AEObject({'date': date, 'timezone': timezone, 'iso8601': iso8601}));
}

/// `$dayOfMonth` operator
class DayOfMonth extends Operator {
  /// Creates `$dayOfMonth` operator expression
  ///
  /// Returns the day of the month for a date as a number between 1 and 31.
  ///
  /// * [date] - The date to which the operator is applied. [date] must be a
  /// valid expression that resolves to a Date, a Timestamp, or an ObjectID.
  /// * {timezone} - Optional. The timezone of the operation result. {timezone}
  /// must be a valid expression that resolves to a string formatted as either
  /// an Olson Timezone Identifier or a UTC Offset. If no timezone is provided,
  /// the result is displayed in UTC.
  DayOfMonth(date, {timezone})
      : super('dayOfMonth', AEObject({'date': date, 'timezone': timezone}));
}

/// `$dayOfWeek` operator
class DayOfWeek extends Operator {
  /// Creates `$dayOfWeek` operator expression
  ///
  /// Returns the day of the week for a date as a number between 1 (Sunday) and
  /// 7 (Saturday).
  ///
  /// * [date] - The date to which the operator is applied. [date] must be a
  /// valid expression that resolves to a Date, a Timestamp, or an ObjectID.
  /// * {timezone} - Optional. The timezone of the operation result. {timezone}
  /// must be a valid expression that resolves to a string formatted as either
  /// an Olson Timezone Identifier or a UTC Offset. If no timezone is provided,
  /// the result is displayed in UTC.
  DayOfWeek(date, {timezone})
      : super('dayOfWeek', AEObject({'date': date, 'timezone': timezone}));
}

/// `$dayOfYear` operator
class DayOfYear extends Operator {
  /// Creates `$dayOfYear` operator expression
  ///
  /// Returns the day of the year for a date as a number between 1 and 366.
  ///
  /// * [date] - The date to which the operator is applied. [date] must be a
  /// valid expression that resolves to a Date, a Timestamp, or an ObjectID.
  /// * {timezone} - Optional. The timezone of the operation result. {timezone}
  /// must be a valid expression that resolves to a string formatted as either
  /// an Olson Timezone Identifier or a UTC Offset. If no timezone is provided,
  /// the result is displayed in UTC.
  DayOfYear(date, {timezone})
      : super('dayOfYear', AEObject({'date': date, 'timezone': timezone}));
}

/// `$hour` operator
class Hour extends Operator {
  /// Creates `$hour` operator expression
  ///
  /// Returns the hour portion of a date as a number between 0 and 23.
  ///
  /// * [date] - The date to which the operator is applied. [date] must be a
  /// valid expression that resolves to a Date, a Timestamp, or an ObjectID.
  /// * {timezone} - Optional. The timezone of the operation result. {timezone}
  /// must be a valid expression that resolves to a string formatted as either
  /// an Olson Timezone Identifier or a UTC Offset. If no timezone is provided,
  /// the result is displayed in UTC.
  Hour(date, {timezone})
      : super('hour', AEObject({'date': date, 'timezone': timezone}));
}

/// `$isoDayOfWeek` operator
class IsoDayOfWeek extends Operator {
  /// Creates `$isoDayOfWeek` operator expression
  ///
  /// Returns the weekday number in ISO 8601 format, ranging from 1 (for Monday)
  /// to 7 (for Sunday).
  ///
  /// * [date] - The date to which the operator is applied. [date] must be a
  /// valid expression that resolves to a Date, a Timestamp, or an ObjectID.
  /// * {timezone} - Optional. The timezone of the operation result. {timezone}
  /// must be a valid expression that resolves to a string formatted as either
  /// an Olson Timezone Identifier or a UTC Offset. If no timezone is provided,
  /// the result is displayed in UTC.
  IsoDayOfWeek(date, {timezone})
      : super('isoDayOfWeek', AEObject({'date': date, 'timezone': timezone}));
}

/// `$isoWeek` operator
class IsoWeek extends Operator {
  /// Creates `$isoWeek` operator expression
  ///
  /// Returns the week number in ISO 8601 format, ranging from 1 to 53. Week
  /// numbers start at 1 with the week (Monday through Sunday) that contains
  /// the year’s first Thursday.
  ///
  /// * [date] - The date to which the operator is applied. [date] must be a
  /// valid expression that resolves to a Date, a Timestamp, or an ObjectID.
  /// * {timezone} - Optional. The timezone of the operation result. {timezone}
  /// must be a valid expression that resolves to a string formatted as either
  /// an Olson Timezone Identifier or a UTC Offset. If no timezone is provided,
  /// the result is displayed in UTC.
  IsoWeek(date, {timezone})
      : super('isoWeek', AEObject({'date': date, 'timezone': timezone}));
}

/// `$isoWeekYear` operator
class IsoWeekYear extends Operator {
  /// Creates `$isoWeekYear` operator expression
  ///
  /// Returns the year number in ISO 8601 format. The year starts with the
  /// Monday of week 1 and ends with the Sunday of the last week.
  ///
  /// * [date] - The date to which the operator is applied. [date] must be a
  /// valid expression that resolves to a Date, a Timestamp, or an ObjectID.
  /// * {timezone} - Optional. The timezone of the operation result. {timezone}
  /// must be a valid expression that resolves to a string formatted as either
  /// an Olson Timezone Identifier or a UTC Offset. If no timezone is provided,
  /// the result is displayed in UTC.
  IsoWeekYear(date, {timezone})
      : super('isoWeekYear', AEObject({'date': date, 'timezone': timezone}));
}

/// `$millisecond` operator
class Millisecond extends Operator {
  /// Creates `$millisecond` operator expression
  ///
  /// Returns the millisecond portion of a date as an integer between 0 and 999.
  ///
  /// * [date] - The date to which the operator is applied. [date] must be a
  /// valid expression that resolves to a Date, a Timestamp, or an ObjectID.
  /// * {timezone} - Optional. The timezone of the operation result. {timezone}
  /// must be a valid expression that resolves to a string formatted as either
  /// an Olson Timezone Identifier or a UTC Offset. If no timezone is provided,
  /// the result is displayed in UTC.
  Millisecond(date, {timezone})
      : super('millisecond', AEObject({'date': date, 'timezone': timezone}));
}

/// `$minute` operator
class Minute extends Operator {
  /// Creates `$minute` operator expression
  ///
  /// Returns the minute portion of a date as a number between 0 and 59.
  ///
  ///
  /// * [date] - The date to which the operator is applied. [date] must be a
  /// valid expression that resolves to a Date, a Timestamp, or an ObjectID.
  /// * {timezone} - Optional. The timezone of the operation result. {timezone}
  /// must be a valid expression that resolves to a string formatted as either
  /// an Olson Timezone Identifier or a UTC Offset. If no timezone is provided,
  /// the result is displayed in UTC.
  Minute(date, {timezone})
      : super('minute', AEObject({'date': date, 'timezone': timezone}));
}

/// `$month` operator
class Month extends Operator {
  /// Creates `$month` operator expression
  ///
  /// Returns the month of a date as a number between 1 and 12.
  ///
  /// * [date] - The date to which the operator is applied. [date] must be a
  /// valid expression that resolves to a Date, a Timestamp, or an ObjectID.
  /// * {timezone} - Optional. The timezone of the operation result. {timezone}
  /// must be a valid expression that resolves to a string formatted as either
  /// an Olson Timezone Identifier or a UTC Offset. If no timezone is provided,
  /// the result is displayed in UTC.
  Month(date, {timezone})
      : super('month', AEObject({'date': date, 'timezone': timezone}));
}

/// `$second` operator
class Second extends Operator {
  /// Creates `$second` operator expression
  ///
  /// Returns the second portion of a date as a number between 0 and 59, but can
  /// be 60 to account for leap seconds.
  ///
  /// * [date] - The date to which the operator is applied. [date] must be a
  /// valid expression that resolves to a Date, a Timestamp, or an ObjectID.
  /// * {timezone} - Optional. The timezone of the operation result. {timezone}
  /// must be a valid expression that resolves to a string formatted as either
  /// an Olson Timezone Identifier or a UTC Offset. If no timezone is provided,
  /// the result is displayed in UTC.
  Second(date, {timezone})
      : super('second', AEObject({'date': date, 'timezone': timezone}));
}

/// `$toDate` operator
class ToDate extends Operator {
  /// Creates `$toDate` operator expression
  ///
  /// Converts a value to a date. If the value cannot be converted to a date,
  /// `$toDate` errors. If the value is `null` or missing, `$toDate` returns `null`.
  ToDate(expr) : super('toDate', expr);
}

/// `$week` operator
class Week extends Operator {
  /// Creates `$week` operator expression
  ///
  /// Returns the week of the year for a date as a number between 0 and 53.
  ///
  /// * [date] - The date to which the operator is applied. [date] must be a
  /// valid expression that resolves to a Date, a Timestamp, or an ObjectID.
  /// * {timezone} - Optional. The timezone of the operation result. {timezone}
  /// must be a valid expression that resolves to a string formatted as either
  /// an Olson Timezone Identifier or a UTC Offset. If no timezone is provided,
  /// the result is displayed in UTC.
  Week(date, {timezone})
      : super('week', AEObject({'date': date, 'timezone': timezone}));
}

/// `$year` operator
class Year extends Operator {
  /// Creates `$year` operator expression
  ///
  /// Returns the year portion of a date.
  ///
  /// * [date] - The date to which the operator is applied. [date] must be a
  /// valid expression that resolves to a Date, a Timestamp, or an ObjectID.
  /// * {timezone} - Optional. The timezone of the operation result. {timezone}
  /// must be a valid expression that resolves to a string formatted as either
  /// an Olson Timezone Identifier or a UTC Offset. If no timezone is provided,
  /// the result is displayed in UTC.
  Year(date, {timezone})
      : super('year', AEObject({'date': date, 'timezone': timezone}));
}
