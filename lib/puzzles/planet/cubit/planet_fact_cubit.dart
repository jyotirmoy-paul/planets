import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/planet.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';

part 'planet_fact_state.dart';

class PlanetFactCubit extends Cubit<PlanetFactState> {
  late Timer _timer;
  Timer? _userInteractionTimer;
  late List<String> facts;
  int currentFactIdx = 0;
  bool hasUserInteracted = false;

  void newFact() {
    // start user interaction timer
    _userInteractionTimer?.cancel();
    _userInteractionTimer = Timer(kS20, () {
      // reset back - so that auto updating works again
      hasUserInteracted = false;
    });

    // get and update new fact
    _updateFact(force: true);

    // this disables the timer temporary, thus not refreshing fact until next cycle
    hasUserInteracted = true;
  }

  void _updateFact({bool force = false}) {
    if (!force) {
      // if there is no `force`, to update fact, then only apply the limiting checks
      if (hasUserInteracted) return;
    }

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

    _timer = Timer.periodic(kS20, (_) => _updateFact());
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}
