import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/models/planet.dart';
import 'package:planets/utils/constants.dart';
import 'package:planets/utils/utils.dart';

part 'planet_fact_state.dart';

class PlanetFactCubit extends Cubit<PlanetFactState> {
  late Timer _timer;
  late List<String> facts;
  int currentFactIdx = 0;

  void _updateFact() {
    int idx = Random().nextInt(facts.length);
    while (idx == currentFactIdx) {
      idx = Random().nextInt(facts.length);
    }

    currentFactIdx = idx;

    final fact = facts[currentFactIdx];
    emit(PlanetFactState(fact: fact));
  }

  PlanetFactCubit({
    required PlanetType planetType,
    required BuildContext context,
  }) : super(const PlanetFactState()) {
    facts = Utils.planetFacts(planetType, context);

    facts.shuffle();

    // update fact for the first time
    _updateFact();

    _timer = Timer.periodic(kS15, (_) => _updateFact());
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}
