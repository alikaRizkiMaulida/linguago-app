import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linguago_flutter/core/constants/language_preference.dart';
import 'package:linguago_flutter/core/theme/app_theme.dart';
import 'package:linguago_flutter/ui/bloc/auth/login/login_bloc.dart';
import 'package:linguago_flutter/ui/bloc/auth/register/register_bloc.dart';
import 'package:linguago_flutter/ui/bloc/quiz/quiz_bloc.dart';
import 'package:linguago_flutter/ui/bloc/leaderboard/leaderboard_bloc.dart';
import 'package:linguago_flutter/ui/bloc/achievement/achievement_bloc.dart';
import 'package:linguago_flutter/ui/bloc/streak/streak_bloc.dart';
import 'package:linguago_flutter/ui/bloc/chat/chat_list_bloc.dart';
import 'package:linguago_flutter/ui/bloc/chat/chat_detail_bloc.dart';
import 'package:linguago_flutter/ui/bloc/script/script_bloc.dart';
import 'package:linguago_flutter/ui/home/home_screen.dart';
import 'package:linguago_flutter/ui/home/intro/forgot_password_screen.dart';
import 'package:linguago_flutter/ui/home/intro/login_screen.dart';
import 'package:linguago_flutter/ui/home/intro/new_password_screen.dart';
import 'package:linguago_flutter/ui/home/intro/onboarding_screen.dart';
import 'package:linguago_flutter/ui/home/intro/otp_screen.dart';
import 'package:linguago_flutter/ui/home/intro/register_screen.dart';
import 'package:linguago_flutter/ui/home/intro/splash_screen.dart';
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
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<RegisterBloc>(create: (context) => RegisterBloc()),
        BlocProvider<QuizBloc>(create: (context) => QuizBloc()),
        BlocProvider<LeaderboardBloc>(create: (context) => LeaderboardBloc()),
        BlocProvider<AchievementBloc>(create: (context) => AchievementBloc()),
        BlocProvider<StreakBloc>(create: (context) => StreakBloc()),
        BlocProvider<ChatListBloc>(create: (context) => ChatListBloc()),
        BlocProvider<ChatDetailBloc>(create: (context) => ChatDetailBloc()),
        BlocProvider<ScriptBloc>(create: (context) => ScriptBloc()),
      ],
      child: MaterialApp(
        title: 'LinguaGo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const SplashScreen(),
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
      ),
    );
  }
}
