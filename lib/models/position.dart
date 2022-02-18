import 'package:equatable/equatable.dart';

class Position extends Equatable implements Comparable<Position> {
  final int x;
  final int y;

  const Position({required this.x, required this.y});

  factory Position.zero() {
    return const Position(x: 0, y: 0);
  }

  Position operator -(Position p) => Position(x: x - p.x, y: y - p.y);

  Position get left => Position(x: x - 1, y: y);
  Position get right => Position(x: x + 1, y: y);
  Position get top => Position(x: x, y: y - 1);
  Position get bottom => Position(x: x, y: y + 1);

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
