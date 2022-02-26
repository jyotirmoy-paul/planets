import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planets/resource/app_assets.dart';
import 'package:flutter/services.dart' show rootBundle;

part 'assetcache_state.dart';

class AssetcacheCubit extends Cubit<AssetcacheState> {
  AssetcacheCubit() : super(const AssetcacheState());

  void startCache() async {
    /// cache by fetching the required assets,
    /// such that next time the app use's the asset from browser's cache, instead of downloading
    for (final asset in AppAssets.assets) {
      await rootBundle.load(asset);
    }

    emit(state.copyWith(isDone: true));
  }
}
