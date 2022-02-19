import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/app/bloc/audio_bloc.dart';

import '../../dashboard/dashboard.dart';
import '../../utils/constants.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AudioBloc()),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: Constants.fontFamily),
        home: const DashboardPage(),
      ),
    );
  }
}
