import 'package:flutter/material.dart';

class SettingBranchPage extends StatelessWidget {
  SettingBranchPage({super.key});

  // Properly type ValueNotifier with an integer value
  final ValueNotifier<int> valuenotif = ValueNotifier<int>(0);
  final List<String> list = ['58 mm', '80 mm'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paper Size Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Paper Size:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<int>(
              valueListenable: valuenotif,
              builder: (context, value, child) {
                return Column(
                  children: [
                    RadioListTile<String>(
                      title: Text(list[0]),
                      value: list[0],
                      groupValue: list[value],
                      onChanged: (selectedValue) {
                        valuenotif.value = 0;
                      },
                    ),
                    RadioListTile<String>(
                      title: Text(list[1]),
                      value: list[1],
                      groupValue: list[value],
                      onChanged: (selectedValue) {
                        valuenotif.value = 1;
                      },
                    ),
                  ],
                );
              },
            ),
            Center(
              child: TextButton.icon(
                label: const Text('Save'),
                onPressed: () {
                  //
                },
                icon: const Icon(Icons.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
