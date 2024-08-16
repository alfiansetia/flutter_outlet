import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/core/assets/assets.gen.dart';
import 'package:flutter_outlet/core/components/alert.dart';
import 'package:flutter_outlet/core/components/buttons.dart';
import 'package:flutter_outlet/core/components/custom_text_field.dart';
import 'package:flutter_outlet/core/components/spaces.dart';
import 'package:flutter_outlet/core/extensions/build_context_ext.dart';
import 'package:flutter_outlet/features/auth/blocs/auth/auth_bloc.dart';
import 'package:flutter_outlet/features/auth/blocs/login/login_bloc.dart';
import 'package:flutter_outlet/features/auth/models/login_request_model.dart';
import 'package:flutter_outlet/features/home/pages/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  @override
  void initState() {
    super.initState();
    usernameController.text = 'admin@gmail.com';
    passwordController.text = 'admin12345';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SpaceHeight(80.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 130.0),
              child: Image.asset(
                Assets.images.logo.path,
                width: 100,
                height: 100,
              )),
          const SpaceHeight(24.0),
          const Center(
            child: Text(
              "POS Outlet",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SpaceHeight(8.0),
          const Center(
            child: Text(
              "Masuk untuk kasir",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
          const SpaceHeight(40.0),
          CustomTextField(
            controller: usernameController,
            label: 'Username',
          ),
          const SpaceHeight(12.0),
          CustomTextField(
            controller: passwordController,
            label: 'Password',
            obscureText: true,
          ),
          const SpaceHeight(24.0),
          BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.loaded) {
                context.read<AuthBloc>().add(const FethAuthEven());
                context.pushReplacement(const DashboardPage());
              }
              if (state.status == LoginStatus.error) {
                Alert(
                  context: context,
                  status: AlertStatus.error,
                  message: state.error.message,
                ).show();
              }
            },
            builder: (context, state) {
              if (state.status == LoginStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Button.filled(
                  icon: const Icon(Icons.login),
                  onPressed: () {
                    context.read<LoginBloc>().add(FetchLoginEven(
                        model: LoginRequestModel(
                            email: usernameController.text,
                            password: passwordController.text)));
                  },
                  label: 'Masuk',
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
