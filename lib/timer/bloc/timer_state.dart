part of 'timer_bloc.dart';

class TimerState extends Equatable {
  final bool isRunning;
  final int secondsElapsed;

  const TimerState({
    this.isRunning = false,
    this.secondsElapsed = 0,
  });

  TimerState copyWith({
    bool? isRunning,
    int? secondsElapsed,
  }) {
    return TimerState(
      isRunning: isRunning ?? this.isRunning,
      secondsElapsed: secondsElapsed ?? this.secondsElapsed,
    );
  }

  @override
  List<Object> get props => [isRunning, secondsElapsed];
}
