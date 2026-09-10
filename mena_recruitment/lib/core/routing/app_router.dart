import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/widgets/bottom_nav_bar.dart';
import 'package:mena_recruitment/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:mena_recruitment/features/jobs/presentation/screens/home_screen.dart';
import 'package:mena_recruitment/features/jobs/presentation/screens/job_details_screen.dart';
import 'package:mena_recruitment/features/applications/presentation/screens/applications_screen.dart';
import 'package:mena_recruitment/features/vault/presentation/screens/vault_screen.dart';
import 'package:mena_recruitment/features/vault/presentation/screens/passport_scan_screen.dart';
import 'package:mena_recruitment/features/vault/presentation/screens/passport_update_screen.dart';
import 'package:mena_recruitment/features/vault/presentation/screens/certifications_screen.dart';
import 'package:mena_recruitment/features/profile/presentation/screens/settings_screen.dart';
import 'package:mena_recruitment/features/cv_parser/presentation/screens/cv_upload_screen.dart';
import 'package:mena_recruitment/features/cv_parser/presentation/screens/cv_review_screen.dart';
import 'package:mena_recruitment/features/sectors/presentation/screens/sectors_screen.dart';
import 'package:mena_recruitment/features/jobs/presentation/screens/job_application_screen.dart';

// Auth State Provider
final isAuthenticatedProvider = StateProvider<bool>((ref) => true);

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.jobs,
    routes: [
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          int currentIndex = 0;
          final location = state.matchedLocation;
          if (location.startsWith(RouteNames.jobs) ||
              location == RouteNames.home) {
            currentIndex = 0;
          } else if (location.startsWith(RouteNames.sectors)) {
            currentIndex = 1;
          } else if (location.startsWith(RouteNames.applications)) {
            currentIndex = 2;
          } else if (location.startsWith(RouteNames.profile)) {
            currentIndex = 3;
          }

          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavBar(
              currentIndex: currentIndex,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go(RouteNames.jobs);
                    break;
                  case 1:
                    context.go(RouteNames.sectors);
                    break;
                  case 2:
                    context.go(RouteNames.applications);
                    break;
                  case 3:
                    context.go(RouteNames.profile);
                    break;
                }
              },
            ),
          );
        },
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteNames.jobs,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteNames.sectors,
            builder: (context, state) => const SectorsScreen(),
          ),
          GoRoute(
            path: RouteNames.applications,
            builder: (context, state) => const ApplicationsScreen(),
          ),
          GoRoute(
            path: RouteNames.profile,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      // Vault sub-screens — accessed via context.push(), no bottom nav
      GoRoute(
        path: RouteNames.vault,
        builder: (context, state) => const VaultScreen(),
        routes: [
          GoRoute(
            path: 'passport-scan',
            builder: (context, state) => const PassportScanScreen(),
          ),
          GoRoute(
            path: 'passport-update',
            builder: (context, state) => const PassportUpdateScreen(),
          ),
          GoRoute(
            path: 'certifications',
            builder: (context, state) => const CertificationsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.jobDetails,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return JobDetailsScreen(jobId: id);
        },
      ),
      GoRoute(
        path: RouteNames.jobApply,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return JobApplicationScreen(jobId: id);
        },
      ),
      GoRoute(
        path: RouteNames.cvUpload,
        builder: (context, state) => const CVUploadScreen(),
      ),
      GoRoute(
        path: RouteNames.cvReview,
        builder: (context, state) => const CVReviewScreen(),
      ),
    ],
  );
});
