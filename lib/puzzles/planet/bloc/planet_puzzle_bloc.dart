import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/ticker.dart';

part 'planet_puzzle_event.dart';
part 'planet_puzzle_state.dart';

class PlanetPuzzleBloc extends Bloc<PlanetPuzzleEvent, PlanetPuzzleState> {
  final int secondsToBegin;

  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  PlanetPuzzleBloc({
    required this.secondsToBegin,
    required Ticker ticker,
  })  : _ticker = ticker,
        super(PlanetPuzzleState(secondsToBegin: secondsToBegin)) {
    on<PlanetCountdownStarted>(_onCountdownStarted);
    on<PlanetCountdownTicked>(_onCountdownTicked);
    on<PlanetCountdownStopped>(_onCountdownStopped);
    on<PlanetCountdownReset>(_onCountdownReset);
    on<PlanetPuzzleResetEvent>(_onPlanetPuzzleResetEvent);
  }

  void _onPlanetPuzzleResetEvent(
    PlanetPuzzleResetEvent event,
    Emitter<PlanetPuzzleState> emit,
  ) {
    emit(state.copyWith(
      secondsToBegin: secondsToBegin,
      isCountdownRunning: false,
    ));
  }

  void _startTicker() {
    _tickerSubscription?.cancel();
    _tickerSubscription =
        _ticker.tick().listen((_) => add(const PlanetCountdownTicked()));
  }

  void _onCountdownStarted(
    PlanetCountdownStarted event,
    Emitter<PlanetPuzzleState> emit,
  ) {
    _startTicker();
    emit(
      state.copyWith(
        isCountdownRunning: true,
        secondsToBegin: secondsToBegin,
      ),
    );
  }

  void _onCountdownTicked(
    PlanetCountdownTicked event,
    Emitter<PlanetPuzzleState> emit,
  ) {
    if (state.secondsToBegin == 0) {
      _tickerSubscription?.pause();
      emit(state.copyWith(isCountdownRunning: false));
    } else {
      emit(state.copyWith(secondsToBegin: state.secondsToBegin - 1));
    }
  }

  void _onCountdownStopped(
    PlanetCountdownStopped event,
    Emitter<PlanetPuzzleState> emit,
  ) {
    _tickerSubscription?.pause();
    emit(
      state.copyWith(
        isCountdownRunning: false,
        secondsToBegin: secondsToBegin,
      ),
    );
  }

  void _onCountdownReset(
    PlanetCountdownReset event,
    Emitter<PlanetPuzzleState> emit,
  ) {
    _startTicker();
    emit(
      state.copyWith(
        isCountdownRunning: true,
        secondsToBegin: event.secondsToBegin,
      ),
    );
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
