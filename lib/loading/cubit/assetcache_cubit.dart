import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'assetcache_state.dart';

class AssetcacheCubit extends Cubit<AssetcacheState> {
  AssetcacheCubit() : super(const AssetcacheState());

  void startCache() async {
    // todo cache, then let know

    // todo: remove this delay - this delay simulates caching time
    await Future.delayed(const Duration(milliseconds: 800));

    emit(state.copyWith(isDone: true));
  }
}
