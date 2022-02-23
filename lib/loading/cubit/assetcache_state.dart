part of 'assetcache_cubit.dart';

class AssetcacheState extends Equatable {
  final bool isDone;
  const AssetcacheState({this.isDone = false});

  AssetcacheState copyWith({
    bool? isDone,
  }) {
    return AssetcacheState(
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  List<Object> get props => [isDone];
}
