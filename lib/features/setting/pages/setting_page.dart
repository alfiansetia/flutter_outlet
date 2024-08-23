import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/extensions/build_context_ext.dart';
import 'package:flutter_outlet/features/setting/blocs/profile/profile_bloc.dart';
import 'package:flutter_outlet/features/setting/pages/printer_setting_page.dart';
import 'package:flutter_outlet/features/setting/pages/profile_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  void _refresh(BuildContext context) {
    context.read<ProfileBloc>().add(const FetchProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    _refresh(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refresh(context);
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            final user = state.user;
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: CachedNetworkImageProvider(
                          user.avatar,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user.email,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Daftar Pengaturan
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(10),
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: const Text('Akun'),
                          subtitle: const Text('Kelola akun anda'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            context.push(const ProfilePage());
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: const Icon(Icons.print),
                          title: const Text('Printer'),
                          subtitle: const Text('Kelola printer'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            context.push(PrinterSettingPage());
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: const Icon(Icons.lock),
                          title: const Text('Privacy'),
                          subtitle: const Text('Manage your privacy settings'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            //
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: const Icon(Icons.help),
                          title: const Text('Help & Support'),
                          subtitle: const Text('Get help and support'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to help & support
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
