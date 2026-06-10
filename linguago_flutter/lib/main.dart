import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linguago_flutter/core/theme/app_theme.dart';
import 'package:linguago_flutter/ui/bloc/auth/login/login_bloc.dart';
import 'package:linguago_flutter/ui/bloc/auth/register/register_bloc.dart';
import 'package:linguago_flutter/ui/pages/home/home_shell_page.dart';
import 'package:linguago_flutter/ui/pages/auth/forgot_password_page.dart';
import 'package:linguago_flutter/ui/pages/auth/login_page.dart';
import 'package:linguago_flutter/ui/pages/auth/new_password_page.dart';
import 'package:linguago_flutter/ui/pages/auth/onboarding_page.dart';
import 'package:linguago_flutter/ui/pages/auth/otp_page.dart';
import 'package:linguago_flutter/ui/pages/auth/register_page.dart';
import 'package:linguago_flutter/ui/pages/auth/verification_email_page.dart';
import 'package:linguago_flutter/ui/pages/auth/splash_page.dart';

import 'package:linguago_flutter/core/constants/quiz_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Pakai font lokal dari pubspec.yaml — jangan download dari internet.
  GoogleFonts.config.allowRuntimeFetching = false;
  await QuizProgress.loadProgress();
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'LinguaGo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const SplashPage(),
        routes: {
          '/onboarding': (_) => const OnboardingPage(),
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/forgot-password': (_) => const ForgotPasswordPage(),
          '/otp': (_) => const OtpPage(),
          '/new-password': (_) => const NewPasswordPage(),
          '/verification-email': (_) => const VerificationEmailPage(),
          '/home': (_) => const HomeShellPage(),
        },
      )
    );
  }
}

