import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_outlet/features/auth/blocs/auth/auth_bloc.dart';
import 'package:flutter_outlet/features/auth/blocs/login/login_bloc.dart';
import 'package:flutter_outlet/features/auth/blocs/logout/logout_bloc.dart';
import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';
import 'package:flutter_outlet/features/branch_menu/blocs/branch_menu/branch_menu_bloc.dart';
import 'package:flutter_outlet/features/cart/blocs/cart/cart_bloc.dart';
import 'package:flutter_outlet/features/home/pages/dashboard_page.dart';
import 'package:flutter_outlet/features/order/blocs/order/order_bloc.dart';
import 'package:flutter_outlet/features/auth/pages/login_page.dart';
import 'package:flutter_outlet/features/printer/blocs/printer/printer_bloc.dart';
import 'package:flutter_outlet/features/setting/blocs/profile/profile_bloc.dart';
import 'package:flutter_outlet/features/setting/blocs/setting/setting_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final auth = AuthRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(),
        ),
        BlocProvider(
          create: (context) => CartBloc(authRepository: auth),
        ),
        BlocProvider(
          create: (context) => OrderBloc(authRepository: auth),
        ),
        BlocProvider(
          create: (context) => BranchMenuBloc(authRepository: auth),
        ),
        BlocProvider(
          create: (context) => PrinterBloc(),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(authRepository: auth),
        ),
        BlocProvider(
          create: (context) => SettingBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          textTheme: GoogleFonts.quicksandTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            color: AppColors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.quicksand(
              color: AppColors.primary,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: const IconThemeData(
              color: AppColors.primary,
            ),
          ),
        ),
        home: FutureBuilder<bool>(
          future: AuthRepository().isLogin(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return const DashboardPage();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
