import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/utils/whatsapp_service.dart';

import 'package:mena_recruitment/features/jobs/data/jobs_repository_impl.dart';

class WalkinDriveDetailsSheet extends StatefulWidget {
  const WalkinDriveDetailsSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const WalkinDriveDetailsSheet(),
    );
  }

  @override
  State<WalkinDriveDetailsSheet> createState() => _WalkinDriveDetailsSheetState();
}

class _WalkinDriveDetailsSheetState extends State<WalkinDriveDetailsSheet> {
  bool _isRegistered = false;
  bool _isRegistering = false;
  String _selectedSlot = '12 Nov - Morning (08:30 AM)';
  String _passCode = 'KSA-WALKIN-2025-99812';
  final JobsRepositoryImpl _jobsRepo = JobsRepositoryImpl();

  final List<String> _timeSlots = [
    '12 Nov - Morning (08:30 AM)',
    '12 Nov - Afternoon (01:30 PM)',
    '13 Nov - Morning (08:30 AM)',
    '13 Nov - Afternoon (01:30 PM)',
    '14 Nov - Jubail Final Session (09:00 AM)',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.event_available_rounded, color: AppColors.primary, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Mega Walk-In Recruitment Drive',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE4DADB)),

          // Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Banner in Sheet
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6E0000), Color(0xFF990000), Color(0xFF3A0006)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: const Text(
                                '🇸🇦 OFFICIAL KSA MEGA DRIVE',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Text(
                              '12–14 NOV 2025',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Oil & Gas Turnaround 2025',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Yanbu & Jubail Petrochemical Complex Projects',
                          style: TextStyle(color: Color(0xFFFFCDD2), fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildMiniPill('1,200+ Quota'),
                            const SizedBox(width: 8),
                            _buildMiniPill('Immediate Visa'),
                            const SizedBox(width: 8),
                            _buildMiniPill('Free Flight & Food'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Drive Venues & Dates
                  const Text('Venues & Schedule', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  const SizedBox(height: 10),
                  _buildVenueCard(
                    date: '12 – 13 November 2025 (Days 1 & 2)',
                    title: 'Yanbu Industrial City Convention Hub',
                    address: 'Gate 3, Royal Commission Industrial Area, Yanbu Al-Sinaiyah, KSA',
                    timing: '08:00 AM – 05:30 PM AST',
                  ),
                  const SizedBox(height: 10),
                  _buildVenueCard(
                    date: '14 November 2025 (Day 3)',
                    title: 'Jubail Technical Training Auditorium',
                    address: 'Support Industrial Area 1, King Fahd Industrial Port Road, Jubail, KSA',
                    timing: '08:30 AM – 04:00 PM AST',
                  ),
                  const SizedBox(height: 20),

                  // Vacancies Breakdown
                  const Text('Open Quota Allocations', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Column(
                      children: [
                        _TradeRow(title: 'Senior Offshore HSE Supervisors', count: '140 Positions', salary: 'SAR 14,000 – 18,000'),
                        Divider(height: 16),
                        _TradeRow(title: 'Refinery Static Equipment Foremen', count: '220 Positions', salary: 'SAR 8,500 – 11,000'),
                        Divider(height: 16),
                        _TradeRow(title: 'TIG / ARC 6G High-Pressure Welders', count: '350 Positions', salary: 'SAR 6,500 – 8,000'),
                        Divider(height: 16),
                        _TradeRow(title: 'Heavy Riggers & Crane Signalmen', count: '280 Positions', salary: 'SAR 5,000 – 6,500'),
                        Divider(height: 16),
                        _TradeRow(title: 'Pipe Fabricators & Millwrights', count: '210 Positions', salary: 'SAR 5,500 – 7,200'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Documents Checklist
                  const Text('Mandatory Documents to Bring', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  const SizedBox(height: 8),
                  _buildDocItem('Original Passport with min. 6 months remaining validity'),
                  _buildDocItem('4 Recent White Background Passport Size Photos'),
                  _buildDocItem('Original Degree / Trade Diploma with MOFA Attestation if available'),
                  _buildDocItem('NEBOSH / OPITO / Aramco Approval Cards (Front & Back)'),
                  _buildDocItem('Updated Physical Hardcopy CV + Digital Vault QR Code'),
                  const SizedBox(height: 24),

                  // Registration Card
                  if (!_isRegistered) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFEDD5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.qr_code_scanner, color: Color(0xFFC2410C), size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Fast-Track Priority Interview Pass',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF9A3412)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Select your preferred arrival slot to receive an encrypted Suhana Walk-in QR Pass and bypass the general line:',
                            style: TextStyle(fontSize: 12, color: Color(0xFF7C2D12)),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedSlot,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFFED7AA))),
                            ),
                            style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600),
                            items: _timeSlots.map((slot) => DropdownMenuItem(value: slot, child: Text(slot))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedSlot = val);
                            },
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            onPressed: _isRegistering
                                ? null
                                : () async {
                                    setState(() => _isRegistering = true);
                                    try {
                                      final drives = await _jobsRepo.getWalkinDrives();
                                      final driveId = drives.isNotEmpty ? drives.first.id : 'drive-yanbu-2025';
                                      final reg = await _jobsRepo.registerForWalkinDrive(driveId, _selectedSlot);
                                      if (!mounted) return;
                                      setState(() {
                                        _passCode = reg.qrPassCode;
                                        _isRegistered = true;
                                        _isRegistering = false;
                                      });
                                    } catch (e) {
                                      if (!mounted) return;
                                      setState(() {
                                        _isRegistered = true;
                                        _isRegistering = false;
                                      });
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC2410C),
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(46),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: _isRegistering
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Icon(Icons.confirmation_number_rounded, size: 18),
                            label: Text(
                              _isRegistering ? 'Generating VIP Pass...' : 'Confirm Slot & Generate QR Pass',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Registered Confirmation Pass
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 22),
                              SizedBox(width: 8),
                              Text(
                                'Priority QR Pass Issued!',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF166534)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Slot: $_selectedSlot',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF15803D)),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFDCFCE7)),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.qr_code_2_rounded, size: 90, color: Color(0xFF166534)),
                                const SizedBox(height: 4),
                                Text(
                                  'PASS: $_passCode',
                                  style: const TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Present this screen at Gate Security for VIP Fast-Track Entry.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: Color(0xFF166534)),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Actions: View Position Details + WhatsApp Support
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.go('${RouteNames.jobs}/job-1');
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            foregroundColor: AppColors.primary,
                            minimumSize: const Size.fromHeight(44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('View Sample Position (PG-HSE-908)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          WhatsAppService.showWhatsAppAssistantSheet(
                            context: context,
                            title: 'Oil & Gas Turnaround Mega Drive',
                            referenceCode: 'KSA-WALKIN-2025',
                            initialMessage: 'Hello Suhana Team, I am planning to attend the Oil & Gas Turnaround Walk-In Drive (12-14 Nov 2025) and need venue guidance.',
                          );
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.chat_rounded, size: 20),
                        tooltip: 'Ask on WhatsApp',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildVenueCard({required String date, required String title, required String address, required String timing}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x05000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  date,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
          const SizedBox(height: 2),
          Text(address, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 12, color: Color(0xFF059669)),
              const SizedBox(width: 4),
              Text(timing, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF059669))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF059669), size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF334155)))),
        ],
      ),
    );
  }
}

class _TradeRow extends StatelessWidget {
  final String title;
  final String count;
  final String salary;

  const _TradeRow({required this.title, required this.count, required this.salary});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
              Text(salary, style: const TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(count, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
        ),
      ],
    );
  }
}
