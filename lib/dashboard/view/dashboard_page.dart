import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/level_selection_cubit.dart';
import '../cubit/planet_selection_cubit.dart';
import '../widgets/header_widget.dart';
import '../widgets/scroll_buttons.dart';
import '../widgets/sun_widget.dart';
import '../../layout/utils/app_breakpoints.dart';
import '../../utils/app_logger.dart';
import '../dashboard.dart';
import '../../layout/utils/responsive_layout_builder.dart';
import 'dart:math' as math;

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
                )),
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
    WidgetsBinding.instance!.addObserver(this);
    context.read<PlanetOrbitalAnimationCubit>().setTickerProvider(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
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
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Container(
        color: Colors.grey[900],
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            // solar system
            ResponsiveLayoutBuilder(
              small: (_, Widget? child) => _DashboardPageSmall(child: child!),
              medium: (_, Widget? child) => _DashboardPageMedium(child: child!),
              large: (_, Widget? child) => child!,
              child: (_) => _DashboardPageLarge(state: state as DashboardReady),
            ),

            // header
            const HeaderWidget(),
          ],
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
      duration: const Duration(milliseconds: 350),
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
          child:
              SizedBox(width: AppBreakpoints.medium, child: widget.solarSystem),
        ),

        // control buttons
        Align(
          alignment: const FractionalOffset(0.50, 0.95),
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
        const SunWidget(),

        // orbits
        ...state.orbits.map<Widget>((orbit) => orbit.widget).toList(),

        // planets
        ...(state).orbits.map<Widget>((orbit) => orbit.planet.widget).toList(),
      ],
    );
  }
}
