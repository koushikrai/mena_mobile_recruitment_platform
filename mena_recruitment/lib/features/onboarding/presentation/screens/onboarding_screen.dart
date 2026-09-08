import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/features/onboarding/presentation/widgets/country_explorer_grid.dart';
import 'package:mena_recruitment/features/onboarding/presentation/widgets/pillar_card.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Global Jobs By Suhana',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F1E36),
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'MENA Recruitment & Relocation Platform',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF059669),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Top Destinations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F1E36),
                ),
              ),
              const SizedBox(height: 16),
              const CountryExplorerGrid(),
              const SizedBox(height: 32),
              const Text(
                'Your Gateway to GCC',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F1E36),
                ),
              ),
              const SizedBox(height: 16),
              const PillarCard(
                icon: Icons.work,
                title: 'Browse Verified GCC Jobs',
                subtitle: 'Direct hiring from top MENA employers',
              ),
              const PillarCard(
                icon: Icons.flight_takeoff,
                title: 'Relocation Assistance',
                subtitle: 'Visa, flight, and housing support',
              ),
              const PillarCard(
                icon: Icons.track_changes,
                title: 'Track Active Applications',
                subtitle: 'Real-time status updates and interviews',
              ),
              const PillarCard(
                icon: Icons.shield,
                title: 'AI CV & Document Vault',
                subtitle: 'Securely store passports and certificates',
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F1E36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    context.go(RouteNames.jobs);
                  },
                  child: const Text('Explore Jobs Now', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    context.push(RouteNames.cvUpload);
                  },
                  child: const Text('Upload CV for AI Match', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0F1E36),
                    side: const BorderSide(color: Color(0xFF0F1E36)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    context.go(RouteNames.vault);
                  },
                  child: const Text('Check Visa Eligibility & Vault', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
