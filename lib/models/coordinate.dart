import 'package:equatable/equatable.dart';

class Coordinate extends Equatable {
  final double x;
  final double y;

  const Coordinate({
    required this.x,
    required this.y,
  });

  @override
  String toString() {
    return '($x, $y)';
  }

  @override
  List<Object?> get props => [x, y];
}
