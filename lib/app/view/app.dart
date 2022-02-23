import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/app/bloc/audio_control_bloc.dart';
import 'package:planets/app/cubit/audio_player_cubit.dart';
import 'package:planets/global/keyboard_handlers/app_keyboard_handler.dart';
import 'package:planets/loading/cubit/assetcache_cubit.dart';
import 'package:planets/loading/view/loading_page.dart';

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
        BlocProvider(create: (_) => AudioControlBloc()),
        BlocProvider(
          create: (context) => AudioPlayerCubit(
            context.read<AudioControlBloc>()
          ),
        ),
        BlocProvider(create: (_) => AssetcacheCubit()),
      ],
      child: AppKeyboardHandler(
        child: MaterialApp(
          theme: ThemeData(fontFamily: Constants.fontFamily),
          home: const LoadingPage(),
        ),
      ),
    );
  }
}
