import 'package:flutter_outlet/features/setting/models/setting.dart';
import 'package:flutter_outlet/features/setting/services/setting_service.dart';
import 'package:flutter_outlet/models/custom_error.dart';

class SettingRepository {
  final _settingServices = SettingService();

  Future<bool> saveData(Setting model) async {
    return await _settingServices.saveData(model);
  }

  Future<Setting> getData() async {
    try {
      return await _settingServices.getData();
    } catch (e) {
      throw const CustomError(message: 'Error get Setting!');
    }
  }
}
