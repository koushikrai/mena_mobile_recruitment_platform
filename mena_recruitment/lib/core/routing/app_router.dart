import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/widgets/bottom_nav_bar.dart'; // Assume it exists

// Placeholder Auth State
final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

final goRouterProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: RouteNames.onboarding,
    redirect: (context, state) {
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isOnboarding = state.matchedLocation == RouteNames.onboarding;

      if (!isAuthenticated && !isAuthRoute && !isOnboarding) {
        return RouteNames.onboarding;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const _PlaceholderScreen(title: 'Onboarding'),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const _PlaceholderScreen(title: 'Login'),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const _PlaceholderScreen(title: 'Register'),
      ),
      GoRoute(
        path: RouteNames.otp,
        builder: (context, state) => const _PlaceholderScreen(title: 'OTP'),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: const BottomNavBar(),
          );
        },
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (context, state) => const _PlaceholderScreen(title: 'Home'),
          ),
          GoRoute(
            path: RouteNames.jobs,
            builder: (context, state) => const _PlaceholderScreen(title: 'Jobs'),
          ),
          GoRoute(
            path: RouteNames.applications,
            builder: (context, state) => const _PlaceholderScreen(title: 'Applications'),
          ),
          GoRoute(
            path: RouteNames.vault,
            builder: (context, state) => const _PlaceholderScreen(title: 'Vault'),
            routes: [
              GoRoute(
                path: 'passport-scan',
                builder: (context, state) => const _PlaceholderScreen(title: 'Passport Scan'),
              ),
              GoRoute(
                path: 'passport-update',
                builder: (context, state) => const _PlaceholderScreen(title: 'Passport Update'),
              ),
              GoRoute(
                path: 'certifications',
                builder: (context, state) => const _PlaceholderScreen(title: 'Certifications'),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.profile,
            builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.jobDetails,
        builder: (context, state) => _PlaceholderScreen(title: 'Job Details: ${state.pathParameters['id']}'),
      ),
      GoRoute(
        path: RouteNames.cvUpload,
        builder: (context, state) => const _PlaceholderScreen(title: 'CV Upload'),
      ),
      GoRoute(
        path: RouteNames.cvReview,
        builder: (context, state) => const _PlaceholderScreen(title: 'CV Review'),
      ),
    ],
  );
});

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
