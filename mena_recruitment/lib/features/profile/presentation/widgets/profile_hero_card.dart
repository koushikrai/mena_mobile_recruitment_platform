import 'package:flutter/material.dart';
import 'package:mena_recruitment/features/profile/domain/candidate_profile_entity.dart';

class ProfileHeroCard extends StatelessWidget {
  final CandidateProfile profile;

  const ProfileHeroCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF990000),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF059669),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              profile.fullName.isNotEmpty ? profile.fullName : 'Candidate Profile',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              profile.targetTitle.isNotEmpty ? profile.targetTitle : 'Complete your profile to unlock GCC matching',
              style: const TextStyle(color: Colors.white70),
            ),
            if (profile.uid.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'UID: ${profile.uid}',
                style: const TextStyle(
                  color: Colors.white54,
                  fontFamily: 'JetBrains Mono',
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (profile.isGccVerified)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: const Color(0xFF059669)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, color: Color(0xFF059669), size: 16),
                    SizedBox(width: 8),
                    Text(
                      'GCC Verified Candidate',
                      style: TextStyle(
                        color: Color(0xFF059669),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
