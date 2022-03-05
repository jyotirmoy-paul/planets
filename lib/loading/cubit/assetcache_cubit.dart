import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../resource/app_assets.dart';
import 'package:flutter/services.dart' show rootBundle;

part 'assetcache_state.dart';

class AssetcacheCubit extends Cubit<AssetcacheState> {
  AssetcacheCubit() : super(const AssetcacheState());

  void startCache() async {
    if (kIsWeb) {
      /// cache by fetching the required assets,
      /// such that next time the app use's the asset from browser's cache, instead of downloading
      for (final asset in AppAssets.assetsToPreFetch) {
        await rootBundle.load(asset);
      }

      // cache other assets, without awaiting
      // this decreases the waiting time in Loading screen
      for (final asset in AppAssets.assetsToPrefetchWithoutAwaiting) {
        rootBundle.load(asset);
      }
    }

    emit(state.copyWith(isDone: true));
  }
}
