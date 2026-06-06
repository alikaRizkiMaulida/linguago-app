import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linguago_flutter/core/theme/app_theme.dart';
import 'package:linguago_flutter/ui/bloc/auth/login/login_bloc.dart';
import 'package:linguago_flutter/ui/bloc/auth/register/register_bloc.dart';
import 'package:linguago_flutter/ui/home/home_screen.dart';
import 'package:linguago_flutter/ui/home/intro/forgot_password_screen.dart';
import 'package:linguago_flutter/ui/home/intro/login_screen.dart';
import 'package:linguago_flutter/ui/home/intro/new_password_screen.dart';
import 'package:linguago_flutter/ui/home/intro/onboarding_screen.dart';
import 'package:linguago_flutter/ui/home/intro/otp_screen.dart';
import 'package:linguago_flutter/ui/home/intro/register_screen.dart';
import 'package:linguago_flutter/ui/home/intro/verification_email_screen.dart';

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
        home: const HomeScreen(),
        routes: {
          '/onboarding': (_) => const OnboardingScreen(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/forgot-password': (_) => const ForgotPasswordScreen(),
          '/otp': (_) => const OtpScreen(),
          '/new-password': (_) => const NewPasswordScreen(),
          '/verification-email': (_) => const VerificationEmailScreen(),
          '/home': (_) => const HomeScreen(),
        },
      )
    );
  }
}

