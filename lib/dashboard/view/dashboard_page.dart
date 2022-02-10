import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/dashboard/cubit/planet_orbital_animation_cubit.dart';
import 'package:planets/dashboard/dashboard.dart';
import 'package:planets/layout/utils/responsive_layout_builder.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PlanetOrbitalAnimationCubit()),
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
    context.read<DashboardBloc>().add(DashboardResized(size));
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ResponsiveLayoutBuilder(
          small: (_, __) => Container(color: Colors.red),
          medium: (_, __) => Container(color: Colors.green),
          large: (_, __) => Stack(
            alignment: Alignment.center,
            children: [
              // orbits
              ...(state as DashboardReady)
                  .orbits
                  .map<Widget>((orbit) => orbit.widget)
                  .toList(),

              // planets
              ...(state)
                  .orbits
                  .map<Widget>((orbit) => orbit.planet.widget)
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
