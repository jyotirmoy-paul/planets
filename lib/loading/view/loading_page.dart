import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:planets/global/stylized_icon.dart';
import '../../l10n/l10n.dart';
import '../../resource/app_assets.dart';
import '../../utils/constants.dart';
import '../../app/cubit/audio_player_cubit.dart';
import '../../dashboard/dashboard.dart';
import '../../global/background/background.dart';
import '../../global/stylized_button.dart';
import '../../global/stylized_container.dart';
import '../../global/stylized_text.dart';
import '../../layout/layout.dart';
import '../cubit/assetcache_cubit.dart';
import '../widgets/loading.dart';
import '../../utils/utils.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  void _move(BuildContext context) async {
    /// we can play the theme music only upon the first interaction
    /// due to chrome policy: https://goo.gl/xX8pDD
    context.read<AudioPlayerCubit>().playThemeMusic();

    final page = await Utils.buildPageAsync(const DashboardPage());

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: kMS800,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioPlayerCubit, AudioPlayerState>(
      listener: (context, state) {
        final bool isReady = state is AudioPlayerReady;
        if (isReady) {
          context.read<AssetcacheCubit>().startCache(context);
        }
      },
      builder: (context, state) {
        final bool isReady = state is AudioPlayerReady;
        final bool isInitialized =
            context.select((AssetcacheCubit cubit) => cubit.state).isDone;

        return Background(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                // project github link
                const _ProjectGithubLink(),

                // body
                ResponsiveLayoutBuilder(
                  small: (_, __) => _LoadingPageSmall(
                    isInitialized: isInitialized,
                    isReady: isReady,
                    onStartPressed: () => _move(context),
                  ),
                  medium: (_, Widget? child) => child!,
                  large: (_, Widget? child) => child!,
                  child: (_) => _LoadingPageLarge(
                    isInitialized: isInitialized,
                    isReady: isReady,
                    onStartPressed: () => _move(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProjectGithubLink extends StatelessWidget {
  const _ProjectGithubLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => Align(
        alignment: Alignment.bottomLeft,
        child: StylizedButton(
          onPressed: Utils.onGithubTap,
          child: const SizedBox(
            width: 70.0,
            child: FittedBox(
              child: StylizedContainer(
                color: Colors.blueGrey,
                child: StylizedIcon(
                  strokeWidth: 4.0,
                  offset: 1.5,
                  icon: FontAwesomeIcons.github,
                ),
              ),
            ),
          ),
        ),
      ),
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (ResponsiveLayoutSize layoutSize) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: StylizedButton(
            onPressed: Utils.onGithubTap,
            child: StylizedContainer(
              color: Colors.blueGrey,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const StylizedIcon(
                    size: 32.0,
                    icon: FontAwesomeIcons.github,
                  ),
                  const Gap(24.0),
                  StylizedText(
                    strokeWidth: 6.0,
                    text: context.l10n.viewOnGithub,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoadingPageLarge extends StatelessWidget {
  final bool isReady;
  final bool isInitialized;
  final VoidCallback onStartPressed;

  const _LoadingPageLarge({
    Key? key,
    required this.isReady,
    required this.isInitialized,
    required this.onStartPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Image.asset(AppAssets.planetsImage),
        ),
        Expanded(
          child: _MainBody(
            isLarge: true,
            isInitialized: isInitialized,
            isReady: isReady,
            onPressed: onStartPressed,
          ),
        ),
      ],
    );
  }
}

class _LoadingPageSmall extends StatelessWidget {
  final bool isReady;
  final bool isInitialized;
  final VoidCallback onStartPressed;

  const _LoadingPageSmall({
    Key? key,
    required this.isReady,
    required this.isInitialized,
    required this.onStartPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // show asset
          Expanded(
            child: Image.asset(AppAssets.planetsImage),
            flex: 5,
          ),

          // show rest body
          Expanded(
            flex: 7,
            child: _MainBody(
              isInitialized: isInitialized,
              isReady: isReady,
              onPressed: onStartPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class _MainBody extends StatelessWidget {
  final bool isReady;
  final bool isInitialized;
  final bool isLarge;
  final VoidCallback onPressed;

  const _MainBody({
    Key? key,
    this.isLarge = false,
    required this.isInitialized,
    required this.isReady,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // app name
        Column(
          children: [
            StylizedText(
              text: context.l10n.appTitle,
              fontSize: isLarge ? 68.0 : 48.0,
              textColor: Utils.darkenColor(Colors.blue),
              strokeColor: Colors.white,
            ),
            const Gap(4.0),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  context.l10n.loadingScreenSubTitle1,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.90),
                    letterSpacing: 1.2,
                    fontSize: isLarge ? 20.0 : 15.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLarge ? 8.0 : 4.0,
                  ),
                  child: Icon(
                    FontAwesomeIcons.solidHeart,
                    color: Colors.redAccent,
                    size: isLarge ? 24.0 : 20.0,
                  ),
                ),
                Text(
                  context.l10n.loadingScreenSubTitle2,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.90),
                    letterSpacing: 1.2,
                    fontSize: isLarge ? 20.0 : 15.0,
                  ),
                ),
              ],
            ),
          ],
        ),

        Column(
          children: [
            // loading animation
            AnimatedSwitcher(
              duration: kMS300,
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: !isInitialized
                  ? Text(
                      context.l10n.loadingScreenInitializing,
                      key: const Key('initializing'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.90),
                        fontSize: isLarge ? 28.0 : 22.0,
                        letterSpacing: 1.4,
                      ),
                    )
                  : Text(
                      context.l10n.loadingScreenReady,
                      key: const Key('ready'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.90),
                        fontSize: isLarge ? 28.0 : 22.0,
                        letterSpacing: 1.4,
                      ),
                    ),
            ),

            const Gap(28.0),

            // loading animation
            AnimatedOpacity(
              duration: kMS300,
              opacity: isReady ? 1.0 : 0.0,
              child: Loading(
                key: ValueKey(isReady),
                tileSize: isLarge ? 60.0 : 40.0,
              ),
            ),
          ],
        ),

        // start button
        StylizedButton(
          onPressed: () {
            if (isReady && isInitialized) {
              onPressed();
            }
          },
          child: StylizedContainer(
            color: isReady && isInitialized ? Colors.greenAccent : Colors.grey,
            child: StylizedText(
              text: context.l10n.start,
              fontSize: isLarge ? 32.0 : 24.0,
            ),
          ),
        ),
      ],
    );
  }
}
