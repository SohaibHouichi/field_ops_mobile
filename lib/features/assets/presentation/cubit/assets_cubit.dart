import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'assets_state.dart';

class AssetsCubit extends Cubit<AssetsState> {
  AssetsCubit() : super(AssetsInitial());
}
