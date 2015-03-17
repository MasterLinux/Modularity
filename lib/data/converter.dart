part of modularity.core.data;

/// Base class for a converter used to
/// convert [TIn] to [TOut] and back.
abstract class Converter<TIn, TOut> {
  TOut convert(TIn value);
  TIn convertBack(TOut value);
}
