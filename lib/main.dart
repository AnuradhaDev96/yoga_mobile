import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/themes/default_text_styles.dart';
import 'dependency_injector.dart';
import 'presentation/blocs/alert_cubit.dart';
import 'presentation/blocs/authentication_bloc.dart';
import 'presentation/states/alert_state.dart';
import 'presentation/states/authentication_state.dart';
import 'presentation/views/anonymous_pages/launcher_page.dart';
import 'presentation/views/home_page/home_page.dart';
import 'utils/constants/app_colors.dart';

void main() {
  DependencyInjector.injectDependencies();
  runApp(const KeepYogaApp());
}

class KeepYogaApp extends StatelessWidget {
  const KeepYogaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlertCubit(),
      child: MaterialApp(
        title: 'keepyoga',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: DefaultTextStyles.defaultFontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.indigo1),
          useMaterial3: true,
        ),
        home: BlocListener<AlertCubit, AlertState>(
          listener: (context, state) {
            // show alert message when state is true
            if (state is AlertOnScreen) {
              AlertCubit().showAlert(context, state.alertMessage, state.alertDuration, state.isErrorMessage);
            }
          },
          child: const SessionHandler(),
        ),
      ),
    );
  }
}

class SessionHandler extends StatelessWidget {
  const SessionHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc()..add(AppStarted()),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationInitial) {
            return const Material(color: Colors.white);
          } else if (state is AuthenticationAuthenticated) {
            return HomePage();
          } else {
            return const LauncherPage();
          }
        },
      ),
    );
  }
}
