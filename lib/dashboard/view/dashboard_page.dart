import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/dashboard/widgets/sun_widget.dart';
import 'package:planets/layout/utils/app_breakpoints.dart';
import '../dashboard.dart';
import '../../layout/utils/responsive_layout_builder.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              PlanetOrbitalAnimationCubit(MediaQuery.of(context).size),
        ),
        BlocProvider(
          create: (c) => DashboardBloc(c.read<PlanetOrbitalAnimationCubit>())
            ..add(DashboardInitialized(MediaQuery.of(context).size)),
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
        child: ResponsiveLayoutBuilder(
          small: (_, __) => _DashboardPageSmall(state: state as DashboardReady),
          medium: (_, __) =>
              _DashboardPageMedium(state: state as DashboardReady),
          large: (_, Widget? child) => child!,
          child: (_) => _DashboardPageLarge(state: state as DashboardReady),
        ),
      ),
    );
  }
}

class _DashboardPageSmall extends StatelessWidget {
  final DashboardReady state;

  const _DashboardPageSmall({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _DashboardPageMedium extends StatelessWidget {
  final DashboardReady state;

  const _DashboardPageMedium({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// class _DashboardPageMedium extends StatefulWidget {
//   final DashboardReady state;

//   const _DashboardPageMedium({
//     Key? key,
//     required this.state,
//   }) : super(key: key);

//   @override
//   State<_DashboardPageMedium> createState() => _DashboardPageMediumState();
// }

// class _DashboardPageMediumState extends State<_DashboardPageMedium> {
//   final _pageViewController = PageController();

//   @override
//   void dispose() {
//     _pageViewController.dispose();
//     super.dispose();
//   }

//   DashboardReady get state => widget.state;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // main body
//         PageView(
//           physics: const ClampingScrollPhysics(),
//           controller: _pageViewController,
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 const SunWidget(),

//                 // orbits
//                 ...state.orbits
//                     .sublist(0, 3)
//                     .map<Widget>((e) => e.widget)
//                     .toList(),

//                 // planets
//                 ...state.orbits
//                     .sublist(0, 3)
//                     .map<Widget>((e) => e.planet.widget)
//                     .toList(),
//               ],
//             ),
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 const SunWidget(scale: 0.70),

//                 // orbits
//                 ...state.orbits
//                     .sublist(3, 6)
//                     .map<Widget>((e) => e.widget)
//                     .toList(),

//                 // planets
//                 ...state.orbits
//                     .sublist(3, 6)
//                     .map<Widget>((e) => e.planet.widget)
//                     .toList(),
//               ],
//             ),
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 const SunWidget(scale: 0.40),

//                 // orbits
//                 ...state.orbits
//                     .sublist(6, 9)
//                     .map<Widget>((e) => e.widget)
//                     .toList(),

//                 // planets
//                 ...state.orbits
//                     .sublist(6, 9)
//                     .map<Widget>((e) => e.planet.widget)
//                     .toList(),
//               ],
//             ),
//           ],
//         ),

//         // bottom controller
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 onPressed: () {
//                   _pageViewController.previousPage(
//                     duration: const Duration(milliseconds: 250),
//                     curve: Curves.easeInOut,
//                   );
//                 },
//                 icon: Icon(Icons.chevron_left_rounded),
//               ),
//               IconButton(
//                 onPressed: () {
//                   _pageViewController.nextPage(
//                     duration: const Duration(milliseconds: 250),
//                     curve: Curves.easeInOut,
//                   );
//                 },
//                 icon: Icon(Icons.chevron_right_rounded),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

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
