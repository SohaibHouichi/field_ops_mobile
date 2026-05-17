part of 'assets_cubit.dart';

sealed class AssetsState {
  const AssetsState();
}

final class AssetsInitial extends AssetsState {
  const AssetsInitial();
}

final class AssetsLoading extends AssetsState {
  const AssetsLoading();
}

final class AssetsSuccess extends AssetsState {
  final List<AssetEmbeddedEntity> assets; 
  const AssetsSuccess(this.assets);
}

final class AssetsError extends AssetsState {
  final String message;
  const AssetsError(this.message);
}