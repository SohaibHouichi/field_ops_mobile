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

final class AssetsSearchSuccess extends AssetsState {
  final List<AssetEntity> assets; 
  const AssetsSearchSuccess(this.assets);
}
final class AssetsSuccess extends AssetsState {
  final AssetEntity asset ; 
  const AssetsSuccess(this.asset);
}
final class EditAssetsSuccessfuly extends AssetsState {
  const EditAssetsSuccessfuly();
}
final class DeleteAssetsSuccessfuly extends AssetsState {
  const DeleteAssetsSuccessfuly();
}

final class AssetsError extends AssetsState {
  final String message;
  const AssetsError(this.message);
}