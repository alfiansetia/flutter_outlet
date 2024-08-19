import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/assets/assets.gen.dart';
import 'package:flutter_outlet/core/components/alert.dart';
import 'package:flutter_outlet/core/components/menu_button.dart';
import 'package:flutter_outlet/core/components/spaces.dart';
import 'package:flutter_outlet/core/extensions/build_context_ext.dart';
import 'package:flutter_outlet/features/auth/blocs/logout/logout_bloc.dart';
import 'package:flutter_outlet/features/auth/pages/login_page.dart';
import 'package:flutter_outlet/features/printer/pages/manage_printer_page.dart';
import 'package:flutter_outlet/features/setting/blocs/profile/profile_bloc.dart';
import 'package:flutter_outlet/features/setting/blocs/setting/setting_bloc.dart';
import 'package:flutter_outlet/features/setting/pages/profile_page.dart';
import 'package:flutter_outlet/features/setting/pages/printer_setting_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                MenuButton(
                  iconPath: Assets.images.manageProduct.path,
                  label: 'Setting Printer',
                  onPressed: () {
                    context.read<SettingBloc>().add(const FetchSettingEvent());
                    context.push(PrinterSettingPage());
                  },
                  isImage: true,
                ),
                const SpaceWidth(15.0),
                MenuButton(
                  iconPath: Assets.images.managePrinter.path,
                  label: 'Kelola Printer',
                  onPressed: () {
                    context.push(const ManagePrinterPage());
                  },
                  isImage: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state.status == ProfileStatus.error) {
                      Alert(
                        status: AlertStatus.error,
                        message: state.message,
                        context: context,
                      ).show();
                    }
                    if (state.status == ProfileStatus.success) {
                      context.push(
                        ProfilePage(
                          user: state.user,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return MenuButton(
                      iconPath: Assets.images.manageProduct.path,
                      label: 'Profile',
                      onPressed: () {
                        context
                            .read<ProfileBloc>()
                            .add(const FetchProfileEvent());
                      },
                      isImage: true,
                    );
                  },
                ),
                const SpaceWidth(15.0),
                MenuButton(
                  iconPath: Assets.images.managePrinter.path,
                  label: 'Sinkronisasi Data',
                  onPressed: () {
                    context.push(const ManagePrinterPage());
                  },
                  isImage: true,
                ),
              ],
            ),
          ),
          const SpaceHeight(60),
          const Divider(),
          BlocConsumer<LogoutBloc, LogoutState>(
            listener: (context, state) {
              if (state.status == LogoutStatus.loaded) {
                context.pushReplacement(const LoginPage());
              }
            },
            builder: (context, state) {
              return TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  context.read<LogoutBloc>().add(const FetchLogoutEvent());
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
