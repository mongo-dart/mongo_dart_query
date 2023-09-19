import '../aggregation_base.dart';
import '../common.dart';

/// Creates an "output" document for the setWinowsDield stage
/// * [fieldName] -Specifies the field to append to the documents in the
///   output returned by the $setWindowFields stage. Each field is set to
///   the result returned by the window operator.
///   A field can contain dots to specify embedded document fields and array
///   fields. The semantics for the embedded document dotted notation in the
///   $setWindowFields stage are the same as the $addFields and $set stages.
///   See embedded document $addFields example and embedded document
///   $set example.
///   * [operator] - The window operator is the window operator
///   to use in the $setWindowFields stage.
///
///   The window operator parameters are the parameters to pass to the window
///   operator. Specifies the window boundaries and parameters. Window
///   boundaries are inclusive. Default is an unbounded window, which includes
///   all documents in the partition.
///   Specify either a documents or range window.
///   - [documents] Optional - A window where the lower and upper boundaries
///     are specified relative to the position of the current document read
///     from the collection.
///     The window boundaries are specified using a two element array
///     containing a lower and upper limit string or integer. Use:
///     - The "current" string for the current document position in the output
///     - The "unbounded" string for the first or last document position in
///       the partition.
///   - [range] Optional - A window where the lower and upper boundaries are
///     defined using a range of values based on the sortBy field in the
///     current document.
///     The window boundaries are specified using a two element array
///     containing a lower and upper limit string or number. Use:
///     - The "current" string for the current document position in the output
///     - The "unbounded" string for the first or last document position in
///       the partition.
///     - A number to add to the value of the sortBy field for the current
///       document. A document is in the window if the sortBy field value is
///       inclusively within the lower and upper boundaries.
/// * [unit] Optional -Specifies the units for time range window boundaries.
///   Can be set to one of these strings:
///   - "year"
///   - "quarter"
///   - "month"
///   - "week"
///   - "day"
///   - "hour"
///   - "minute"
///   - "second"
///   - "millisecond"
///
///   If omitted, default numeric range window boundaries are used.
class Output extends AEObject {
  Output(String fieldName, Accumulator operator,
      {List? documents, List? range, String? unit})
      : super.internal(({
          fieldName: {
            ...operator.build(),
            if (documents != null || range != null || unit != null)
              spWindow: {
                if (documents != null) spDocuments: AEList(documents),
                if (range != null) spRange: AEList(range),
                if (unit != null) spUnit: unit
              }
          }
        }));
}
