import 'package:field_ops/core/helpers/shared_pref_helper.dart';
import 'package:field_ops/core/local_storage/local_storage_data.dart';

class LocalStorageDataImpl implements LocalStorageData {
  @override
  Future<int> getDataFromLocalStorage() async {
    final id = await SharedPrefHelper.getInt(LocalStorageKeys.userId);
    return id.toInt();
  }
}