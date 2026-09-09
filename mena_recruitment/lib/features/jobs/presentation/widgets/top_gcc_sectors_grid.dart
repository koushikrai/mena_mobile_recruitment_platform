import 'package:flutter/material.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/features/jobs/presentation/screens/all_gcc_sectors_screen.dart';

class TopGccSectorsGrid extends StatelessWidget {
  final Function(String sector)? onSelectSector;

  const TopGccSectorsGrid({super.key, this.onSelectSector});

  @override
  Widget build(BuildContext context) {
    final sectors = [
      _SectorInfo(
        title: 'Oil & Gas',
        roles: 'Riggers, Welders, HSE',
        jobCount: '450+ Jobs',
        icon: Icons.oil_barrel_rounded,
      ),
      _SectorInfo(
        title: 'Facility Mgmt',
        roles: 'MEP, HVAC, Security',
        jobCount: '620+ Jobs',
        icon: Icons.build_circle_rounded,
      ),
      _SectorInfo(
        title: 'Healthcare',
        roles: 'Nurses, MOH, DHA',
        jobCount: '280+ Jobs',
        icon: Icons.local_hospital_rounded,
      ),
      _SectorInfo(
        title: 'Hospitality',
        roles: 'Chefs, Baristas, Hotel',
        jobCount: '340+ Jobs',
        icon: Icons.room_service_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top GCC Sectors',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  'High-demand quota industries',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AllGccSectorsScreen(),
                  ),
                );
              },
              icon: const Text(
                'EXPLORE ALL',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              label: const Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.45,
          ),
          itemCount: sectors.length,
          itemBuilder: (context, index) {
            final sector = sectors[index];
            return InkWell(
              onTap: () => onSelectSector?.call(sector.title),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF2F2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFF0DCD9)),
                          ),
                          child: Icon(sector.icon, color: AppColors.primary, size: 20),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF2F2),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            sector.jobCount,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sector.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          sector.roles,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SectorInfo {
  final String title;
  final String roles;
  final String jobCount;
  final IconData icon;

  _SectorInfo({
    required this.title,
    required this.roles,
    required this.jobCount,
    required this.icon,
  });
}
