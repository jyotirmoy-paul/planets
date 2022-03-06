import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../resource/app_assets.dart';

part 'assetcache_state.dart';

class AssetcacheCubit extends Cubit<AssetcacheState> {
  AssetcacheCubit() : super(const AssetcacheState());

  void startCache(BuildContext context) async {
    if (kIsWeb) {
      /// cache by fetching the required assets,
      /// such that next time the app use's the asset from browser's cache, instead of downloading
      for (final asset in AppAssets.assetsToPreFetch) {
        await precacheImage(Image.asset(asset).image, context);
      }

      // cache other assets, without awaiting
      // this decreases the waiting time in Loading screen
      for (final asset in AppAssets.extraAssetsToPrefetch) {
        unawaited(precacheImage(Image.asset(asset).image, context));
      }

      // animation assets to prefetch
      for (final asset in AppAssets.animationAssetsToPrefetch) {
        unawaited(rootBundle.load(asset));
      }
    }

    emit(state.copyWith(isDone: true));
  }
}
