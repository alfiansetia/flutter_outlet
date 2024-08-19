import 'package:flutter_outlet/features/setting/models/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingService {
  Future<bool> saveData(Setting model) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString('setting', model.toJson());
  }

  Future<Setting> getData() async {
    Setting newSetting = Setting.initial();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final stringSetting = pref.getString('setting') ?? '';
    if (stringSetting.isEmpty) {
      saveData(newSetting);
      return newSetting;
    }
    return Setting.fromJson(stringSetting);
  }
}
