import 'package:equatable/equatable.dart';

class Position extends Equatable implements Comparable<Position> {
  final int x;
  final int y;

  const Position({required this.x, required this.y});

  @override
  List<Object> get props => [x, y];

  @override
  int compareTo(Position other) {
    if (y < other.y) {
      return -1;
    } else if (y > other.y) {
      return 1;
    } else {
      if (x < other.x) {
        return -1;
      } else if (x > other.x) {
        return 1;
      } else {
        return 0;
      }
    }
  }
}
