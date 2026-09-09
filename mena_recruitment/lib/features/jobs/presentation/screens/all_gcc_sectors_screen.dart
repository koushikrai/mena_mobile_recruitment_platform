import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/features/jobs/providers/job_filter_provider.dart';

class AllGccSectorsScreen extends ConsumerWidget {
  const AllGccSectorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<_GccSectorDetail> sectors = [
      const _GccSectorDetail(
        title: 'Oil, Gas & Offshore Petrochemicals',
        tag: 'Oil & Gas',
        icon: Icons.oil_barrel_rounded,
        jobsCount: '450+ Verified Jobs',
        activeProjects: 'Yanbu, Jubail, Ras Tanura & Marjan Field',
        avgSalary: 'SAR 14,000 – 28,000 / mo (Tax-Free)',
        roles: ['Senior Offshore HSE Supervisors', '6G High-Pressure Welders', 'Rigging Superintendents', 'Turnaround Planners'],
        certifications: ['NEBOSH IGC', 'OPITO BOSIET', 'Saudi Aramco SAP ID'],
      ),
      const _GccSectorDetail(
        title: 'Total Facilities Management & MEP',
        tag: 'Facility Mgmt',
        icon: Icons.build_circle_rounded,
        jobsCount: '620+ Verified Jobs',
        activeProjects: 'Dubai Marina Towers, Riyadh Giga-Assets & Lusail City',
        avgSalary: 'AED 6,500 – 14,000 / mo',
        roles: ['Lead MEP Project Technicians', 'HVAC Central Chiller Operators', 'BMS Automation Foremen', 'Fire Alarm Engineers'],
        certifications: ['Diploma in Mech/Elec', 'GCC Driving License', 'Civil Defense Card'],
      ),
      const _GccSectorDetail(
        title: 'Healthcare & Critical Care Nursing',
        tag: 'Healthcare',
        icon: Icons.local_hospital_rounded,
        jobsCount: '280+ Verified Jobs',
        activeProjects: 'Hamad Medical Qatar, SEHA Abu Dhabi & MOH KSA',
        avgSalary: 'QAR 9,000 – 18,000 / mo',
        roles: ['ICU & ER Staff Nurses', 'Biomedical Equipment Specialists', 'Lab Technologists', 'Anesthesia Technicians'],
        certifications: ['Qatar Prometric / QCHP', 'DataFlow PSV', 'BLS / ACLS'],
      ),
      const _GccSectorDetail(
        title: 'Luxury Hospitality & Culinary Arts',
        tag: 'Hospitality',
        icon: Icons.room_service_rounded,
        jobsCount: '340+ Verified Jobs',
        activeProjects: 'Red Sea Global Resorts, Four Seasons Bahrain & Atlantis Dubai',
        avgSalary: 'SAR 7,500 – 18,500 / mo + Service Charge',
        roles: ['Executive Head Chefs', 'Pastry & Bakery Specialists', 'F&B Outlet Managers', 'Guest Experience Concierge'],
        certifications: ['HACCP Certified', 'Culinary Arts Diploma', 'WSET Level 2'],
      ),
      const _GccSectorDetail(
        title: 'Civil Infrastructure & Giga-Projects',
        tag: 'Construction',
        icon: Icons.architecture_rounded,
        jobsCount: '510+ Verified Jobs',
        activeProjects: 'NEOM The Line, Qiddiya, King Salman Park & Riyadh Metro',
        avgSalary: 'SAR 18,000 – 35,000 / mo',
        roles: ['Senior Civil Infrastructure Engineers', 'Tunneling & Geotech Specialists', 'QA/QC Managers', 'Survey Superintendents'],
        certifications: ['SCE Consultant Registration', 'FIDIC Contracts', 'AutoCAD / Civil 3D'],
      ),
      const _GccSectorDetail(
        title: 'Maritime Ports & Transshipment Logistics',
        tag: 'Maritime & Port',
        icon: Icons.directions_boat_rounded,
        jobsCount: '190+ Verified Jobs',
        activeProjects: 'Port of Salalah, Jebel Ali DP World & King Abdullah Port',
        avgSalary: 'OMR 950 – 1,800 / mo',
        roles: ['Container Berth Superintendents', 'Stevedoring Supervisors', 'Harbor Tug Masters', 'Customs Clearance Agents'],
        certifications: ['TOS Systems', 'ISPS Code', 'Dangerous Goods IMDG'],
      ),
      const _GccSectorDetail(
        title: 'Renewable Solar & Desalination Utilities',
        tag: 'Energy',
        icon: Icons.solar_power_rounded,
        jobsCount: '160+ Verified Jobs',
        activeProjects: 'ACWA Power Sudair PV, DEWA Solar Park & SWRO Jubail',
        avgSalary: 'SAR 16,000 – 26,000 / mo',
        roles: ['Solar PV Grid Inverter Technicians', 'Reverse Osmosis Plant Supervisors', 'High Voltage Substation Techs'],
        certifications: ['PV Technical Certification', 'SCADA Controls', 'SEC Qualified'],
      ),
      const _GccSectorDetail(
        title: 'Heavy Transport & Mobile Equipment',
        tag: 'Heavy Equipment',
        icon: Icons.local_shipping_rounded,
        jobsCount: '230+ Verified Jobs',
        activeProjects: 'Mammoet Gulf, Eastern Province Heavy Corridors',
        avgSalary: 'SAR 6,500 – 11,000 / mo + Overtime',
        roles: ['Hydraulic Mobile Crane Operators (100T+)', 'Lowbed Heavy Trailer Drivers', 'Forklift / Reach Stacker Operators'],
        certifications: ['KSA Heavy Driving License (Rukhsah)', 'Aramco Third Party Crane Cert'],
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE4DADB), width: 0.5)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1B1B)),
                    onPressed: () => context.pop(),
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'All GCC High-Demand Sectors',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1B1B)),
                      ),
                      Text(
                        'GOVERNMENT SPONSORED QUOTA RECRUITMENT',
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 0.8),
                      ),
                    ],
                  ),
                  const SizedBox(width: 48), // Balance back button
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sectors.length,
        separatorBuilder: (ctx, i) => const SizedBox(height: 14),
        itemBuilder: (ctx, index) {
          final sector = sectors[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE4DADB)),
              boxShadow: const [
                BoxShadow(color: Color(0x06000000), blurRadius: 6, offset: Offset(0, 2)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF2F2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF0DCD9)),
                        ),
                        child: Icon(sector.icon, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sector.title,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1B1B)),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    sector.jobsCount,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Key Projects: ${sector.activeProjects}',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.payments_outlined, size: 14, color: Color(0xFF059669)),
                      const SizedBox(width: 4),
                      Text(
                        sector.avgSalary,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('High-Demand Roles:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: sector.roles.map((r) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(r, style: const TextStyle(fontSize: 10, color: Color(0xFF334155), fontWeight: FontWeight.w600)),
                        )).toList(),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(jobFilterProvider.notifier).clearFilters();
                            ref.read(jobFilterProvider.notifier).setSearchQuery(sector.tag);
                            context.go(RouteNames.jobs);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('View ${sector.tag} Jobs', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
    );
  }
}

class _GccSectorDetail {
  final String title;
  final String tag;
  final IconData icon;
  final String jobsCount;
  final String activeProjects;
  final String avgSalary;
  final List<String> roles;
  final List<String> certifications;

  const _GccSectorDetail({
    required this.title,
    required this.tag,
    required this.icon,
    required this.jobsCount,
    required this.activeProjects,
    required this.avgSalary,
    required this.roles,
    required this.certifications,
  });
}
