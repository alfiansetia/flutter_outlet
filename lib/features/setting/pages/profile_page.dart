import 'package:flutter/material.dart';

import 'package:flutter_outlet/models/user.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  const ProfilePage({
    super.key,
    required this.user,
  });

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
