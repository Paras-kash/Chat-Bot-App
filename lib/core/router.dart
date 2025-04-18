import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/presentation/pages/login_page.dart';
import 'package:flutter_application_1/presentation/pages/signup_page.dart';
import 'package:flutter_application_1/presentation/pages/chatbot_page.dart';
import 'package:flutter_application_1/presentation/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isLoginRoute = state.matchedLocation == '/login';
      final isSignupRoute = state.matchedLocation == '/signup';
      
      // If not logged in and not on auth routes, redirect to login
      if (!isLoggedIn && !isLoginRoute && !isSignupRoute) {
        return '/login';
      }
      
      // If logged in and on auth routes, redirect to chatbot
      if (isLoggedIn && (isLoginRoute || isSignupRoute)) {
        return '/chatbot';
      }
      
      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/chatbot',
        builder: (context, state) => const ChatbotPage(),
      ),
    ],
  );
});