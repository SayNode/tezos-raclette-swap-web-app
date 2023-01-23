class ChartDatapoint {
  /// Initialize the instance of the [ChartDatapoint] class.
  ChartDatapoint({required this.x, required this.y});

  /// Spline series x points.
  double x;

  /// Spline series y points.
  double y;

  ChartDatapoint operator +(ChartDatapoint other) {
    assert(y == other.y);
    return ChartDatapoint(x: x, y: y + other.y);
  }

  @override
  String toString() {
    return 'x: $x, y: $y';
  }
}
