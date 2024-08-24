import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/components/alert.dart';
import 'package:flutter_outlet/core/extensions/build_context_ext.dart';
import 'package:flutter_outlet/features/printer/pages/manage_printer_page.dart';
import 'package:flutter_outlet/features/setting/blocs/setting/setting_bloc.dart';
import 'package:flutter_outlet/features/setting/models/setting.dart';

class PrinterSettingPage extends StatelessWidget {
  PrinterSettingPage({super.key});

  final ValueNotifier<int> valuenotif = ValueNotifier<int>(0);
  final List<String> labelList = ['58 mm', '80 mm'];
  final List<PaperSetting> paperList = [PaperSetting.mm58, PaperSetting.mm80];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Setting'),
      ),
      body: BlocConsumer<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state.status == SettingStatus.error ||
              state.status == SettingStatus.success) {
            Alert(
              status: state.status == SettingStatus.success
                  ? AlertStatus.success
                  : AlertStatus.error,
              message: state.message,
              context: context,
            ).show();
          }
        },
        builder: (context, state) {
          if (state.status == SettingStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.setting.paper == PaperSetting.mm58) {
            valuenotif.value = 0;
          } else {
            valuenotif.value = 1;
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Default MAC Printer:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          state.setting.defaultMac,
                          overflow: TextOverflow
                              .ellipsis, // Mengatasi overflow dengan memotong teks
                          style: const TextStyle(
                              fontSize:
                                  16), // Sesuaikan ukuran teks jika diperlukan
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          context
                              .read<SettingBloc>()
                              .add(const FetchSettingEvent());
                          context.push(const ManagePrinterPage());
                        },
                        icon: const Icon(Icons.print),
                        label: const Text('Ubah Printer'),
                      ),
                    ],
                  ),
                  const Text(
                    'Pilih ukuran kertas:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: valuenotif,
                    builder: (context, value, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(labelList[0]),
                              value: labelList[0],
                              groupValue: labelList[value],
                              onChanged: (selectedValue) {
                                valuenotif.value = 0;
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(labelList[1]),
                              value: labelList[1],
                              groupValue: labelList[value],
                              onChanged: (selectedValue) {
                                valuenotif.value = 1;
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                      onPressed: () {
                        context.read<SettingBloc>().add(
                              SaveSettingEvent(
                                setting: state.setting.copyWith(
                                    paper: paperList[valuenotif.value]),
                              ),
                            );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
