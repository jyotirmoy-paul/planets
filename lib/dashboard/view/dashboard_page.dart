import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/dashboard/dashboard.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DashboardBloc()
            ..add(DashboardInitialized(MediaQuery.of(context).size)),
        ),
      ],
      child: const _DashboardView(),
    );
  }
}

// Positioned(
//               left: -size * 0.50,
//               child: Container(
//                 width: size * 0.70,
//                 height: size * 0.70,
//                 decoration: BoxDecoration(
//                   color: Colors.yellowAccent,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),

class _DashboardView extends StatelessWidget {
  const _DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.select((DashboardBloc bloc) => bloc.state);

    if (state is DashboardLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: Container(
        color: Colors.grey[800],
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: (state as DashboardInited)
              .orbits
              .map<Widget>((orbit) => orbit.widget)
              .toList(),
        ),
      ),
    );
  }
}
