import 'package:equatable/equatable.dart';

class Position extends Equatable implements Comparable<Position> {
  final int x;
  final int y;

  const Position({required this.x, required this.y});

  Position operator -(Position p) => Position(x: x - p.x, y: y - p.y);

  @override
  bool operator ==(Object other) {
    return other is Position && (x == other.x && y == other.y);
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  List<Object> get props => [x, y];

  @override
  String toString() {
    return 'Position($x, $y)';
  }

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
