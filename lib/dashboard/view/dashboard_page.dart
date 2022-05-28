import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:planets/utils/quick_visit_counter.dart';

import '../../global/background/background.dart';
import '../../global/controls/audio_control.dart';
import '../../global/info_card/info_card.dart';
import '../../global/keyboard_handlers/dashboard_keyboard_handler.dart';
import '../../global/stylized_button.dart';
import '../../global/stylized_container.dart';
import '../../global/stylized_icon.dart';
import '../../layout/utils/app_breakpoints.dart';
import '../../layout/utils/responsive_layout_builder.dart';
import '../../utils/constants.dart';
import '../cubit/level_selection_cubit.dart';
import '../cubit/planet_selection_cubit.dart';
import '../cubit/planet_selection_helper_cubit.dart';
import '../dashboard.dart';
import '../widgets/header_widget.dart';
import '../widgets/scroll_buttons.dart';
import '../widgets/sun_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PlanetOrbitalAnimationCubit(size),
        ),
        BlocProvider(
          create: (c) => DashboardBloc(c.read<PlanetOrbitalAnimationCubit>())
            ..add(DashboardInitialized(size)),
        ),
        BlocProvider(create: (_) => LevelSelectionCubit()),
        BlocProvider(
          create: (c) => PlanetSelectionCubit(
            c.read<LevelSelectionCubit>(),
            context,
          ),
        ),
        BlocProvider(
          create: (c) => PlanetSelectionHelperCubit(
            planetAnimationCubit: c.read<PlanetOrbitalAnimationCubit>(),
          ),
        ),
      ],
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView({Key? key}) : super(key: key);

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Size get size => MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<PlanetOrbitalAnimationCubit>().setTickerProvider(this);
    QuickVisitCounter.countDashboardPageOpened();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final s = size;
    if (s.width > AppBreakpoints.medium) {
      context.read<DashboardBloc>().add(DashboardResized(s));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((DashboardBloc bloc) => bloc.state);

    if (state is DashboardLoading) {
      return const SizedBox.shrink();
    }

    return DashboardKeyboardHandler(
      orbits: (state as DashboardReady).orbits,
      child: Background(
        child: SizedBox.fromSize(
          size: size,
          child: Stack(
            children: [
              // solar system
              ResponsiveLayoutBuilder(
                small: (_, Widget? child) => _DashboardPageSmall(child: child!),
                medium: (_, Widget? child) =>
                    _DashboardPageMedium(child: child!),
                large: (_, Widget? child) => child!,
                child: (_) => _DashboardPageLarge(state: state),
              ),

              // header
              const HeaderWidget(),

              // music control
              ResponsiveLayoutBuilder(
                small: (_, __) => const SizedBox.shrink(),
                medium: (_, __) => const SizedBox.shrink(),
                large: (_, __) => const Align(
                  alignment: kFOTopRight,
                  child: AudioControl(),
                ),
              ),

              // planet animation pause/play button
              const Align(
                alignment: kFOBottomRight,
                child: _PlanetAnimationToggleButton(),
              ),

              // info button
              ResponsiveLayoutBuilder(
                small: (_, __) => const Align(
                  alignment: kFOBottomLeft,
                  child: _InfoButton(),
                ),
                medium: (_, __) => const Align(
                  alignment: kFOTopLeft,
                  child: _InfoButton(),
                ),
                large: (_, __) => const Align(
                  alignment: kFOTopLeft,
                  child: _InfoButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoButton extends StatelessWidget {
  const _InfoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StylizedButton(
      onPressed: () {
        InfoCard.show(context: context);
      },
      child: const StylizedContainer(
        padding: EdgeInsets.all(12.0),
        color: Colors.greenAccent,
        child: StylizedIcon(
          icon: FontAwesomeIcons.info,
          size: 15.0,
          offset: 1.0,
          strokeWidth: 5.0,
        ),
      ),
    );
  }
}

class _PlanetAnimationToggleButton extends StatelessWidget {
  const _PlanetAnimationToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state =
        context.select((PlanetSelectionHelperCubit cubit) => cubit.state);

    final bool isPaused = state.isPaused;

    return StylizedButton(
      onPressed: () {
        context.read<PlanetSelectionHelperCubit>().onPlanetMovementToggle();
      },
      child: StylizedContainer(
        color: isPaused ? Colors.grey : Colors.blueAccent,
        padding: const EdgeInsets.all(12.0),
        child: StylizedIcon(
          icon: isPaused ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
          size: 15.0,
          offset: 1.0,
          strokeWidth: 5.0,
        ),
      ),
    );
  }
}

class _DashboardPageSmall extends StatelessWidget {
  final Widget child;

  const _DashboardPageSmall({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ScrollableSolarSystem(solarSystem: child);
  }
}

class _DashboardPageMedium extends StatelessWidget {
  final Widget child;

  const _DashboardPageMedium({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ScrollableSolarSystem(solarSystem: child);
  }
}

class _ScrollableSolarSystem extends StatefulWidget {
  final Widget solarSystem;

  const _ScrollableSolarSystem({
    Key? key,
    required this.solarSystem,
  }) : super(key: key);

  @override
  State<_ScrollableSolarSystem> createState() => _ScrollableSolarSystemState();
}

class _ScrollableSolarSystemState extends State<_ScrollableSolarSystem> {
  final _controller = ScrollController();

  double get width => MediaQuery.of(context).size.width;

  double _scrollOffset = 0.0;

  void _scrollListener() {
    _scrollOffset = _controller.offset;
  }

  void _moveToOffset() {
    _controller.animateTo(
      _scrollOffset,
      duration: kMS350,
      curve: Curves.easeInOut,
    );
  }

  void _onMoveNext() {
    _scrollOffset =
        math.min(AppBreakpoints.medium - width, _scrollOffset + width);
    _moveToOffset();
  }

  void _onMovePrev() {
    _scrollOffset = math.max(0.0, _scrollOffset - width);
    _moveToOffset();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // solar system
        SingleChildScrollView(
          controller: _controller,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: AppBreakpoints.medium,
            child: widget.solarSystem,
          ),
        ),

        // control buttons
        Align(
          alignment: kFOBottomCenter,
          child: ScrollButtons(onPrevious: _onMovePrev, onNext: _onMoveNext),
        ),
      ],
    );
  }
}

class _DashboardPageLarge extends StatelessWidget {
  final DashboardReady state;

  const _DashboardPageLarge({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // sun
        const SunWidget(
          key: Key('Sun'),
        ),

        // orbits
        ...state.orbits.map<Widget>((orbit) => orbit.widget).toList(),

        // planets
        ...(state).orbits.map<Widget>((orbit) => orbit.planet.widget).toList(),
      ],
    );
  }
}
