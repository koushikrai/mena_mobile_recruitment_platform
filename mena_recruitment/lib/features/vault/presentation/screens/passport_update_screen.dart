import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PassportUpdateScreen extends ConsumerStatefulWidget {
  const PassportUpdateScreen({super.key});

  @override
  ConsumerState<PassportUpdateScreen> createState() => _PassportUpdateScreenState();
}

class _PassportUpdateScreenState extends ConsumerState<PassportUpdateScreen> {
  bool _remind6Months = true;
  bool _remind3Months = true;
  bool _remind1Month = true;
  bool _isHistoryExpanded = false;

  final TextEditingController _passportNoController = TextEditingController(text: 'N8492014');
  final TextEditingController _nameController = TextEditingController(text: 'AHMED MANSOOR AL-FAROOQ');
  final TextEditingController _placeOfIssueController = TextEditingController(text: 'Cairo, Egypt');
  final TextEditingController _issueDateController = TextEditingController(text: '10 Jan 2021');
  final TextEditingController _expiryDateController = TextEditingController(text: '09 Jan 2028');

  @override
  void dispose() {
    _passportNoController.dispose();
    _nameController.dispose();
    _placeOfIssueController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryCrimson = Color(0xFF6E0000);
    const containerCrimson = Color(0xFF990000);
    const lightSurface = Color(0xFFF9F9FF);
    const cardLowest = Colors.white;
    const cardLow = Color(0xFFF1F3FD);
    const cardHigh = Color(0xFFE5E8F2);
    const textOnSurface = Color(0xFF181C23);
    const textSecondary = Color(0xFF5A5F67);

    return Scaffold(
      backgroundColor: lightSurface,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Container(
              color: cardLowest,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => context.pop(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: cardLow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back, color: textOnSurface, size: 20),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFFFD4D4)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.shield, color: containerCrimson, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'SUHANA GLOBAL',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                    color: primaryCrimson,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: cardLow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.help_outline, color: primaryCrimson, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(Icons.verified_user, size: 13, color: primaryCrimson),
                      SizedBox(width: 4),
                      Text(
                        'EXECUTIVE GLOBAL MOBILITY DOSSIER',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: primaryCrimson,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Passport & Travel Document',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textOnSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Text(
                    'Manage your travel identity, renewal updates, and GCC visa compliance safeguards.',
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Active Pipeline Notice
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4F4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFE2E2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDAD4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.sync_problem, color: primaryCrimson, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Active Pipeline Notice (2 Direct Roles)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: primaryCrimson,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: primaryCrimson,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        'Saudi & UAE',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Text.rich(
                                  TextSpan(
                                    text: 'Updating bio-page data automatically triggers sync with your Lead Advisor ',
                                    style: TextStyle(fontSize: 11, color: textSecondary, height: 1.4),
                                    children: [
                                      TextSpan(
                                        text: 'Eng. Tariq Al-Ghamdi',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: textOnSurface),
                                      ),
                                      TextSpan(text: ' & '),
                                      TextSpan(
                                        text: 'PetroGulf Energy HR',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: textOnSurface),
                                      ),
                                      TextSpan(
                                        text: ' to maintain Muqeem & MOHRE labor permit validity without flight disruption.',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Primary Travel Document Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.badge, size: 18, color: textOnSurface),
                                  SizedBox(width: 8),
                                  Text(
                                    'Primary Travel Document',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textOnSurface,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: cardLow,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  children: [
                                    CircleAvatar(radius: 3, backgroundColor: containerCrimson),
                                    SizedBox(width: 5),
                                    Text(
                                      'Active in Embassy File',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textOnSurface),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Inner Passport Ticket Graphic
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cardHigh,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Text('🇪🇬', style: TextStyle(fontSize: 24)),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'ISSUING STATE / CODE',
                                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: textSecondary),
                                            ),
                                            Text(
                                              'EGYPT (EGY)',
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textOnSurface),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'DOCUMENT NO.',
                                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: textSecondary),
                                        ),
                                        Text(
                                          _passportNoController.text,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: primaryCrimson,
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'HOLDER LEGAL NAME (ICAO STD)',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: textSecondary),
                                ),
                                Text(
                                  _nameController.text,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textOnSurface,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // GCC Clearance Meter
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: cardLowest,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.flight_takeoff, size: 14, color: primaryCrimson),
                                              SizedBox(width: 4),
                                              Text(
                                                'GCC Visa Clearance Status',
                                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textOnSurface),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Expires in 2.8 Years',
                                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryCrimson),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: const LinearProgressIndicator(
                                          value: 0.78,
                                          minHeight: 6,
                                          backgroundColor: cardLow,
                                          valueColor: AlwaysStoppedAnimation<Color>(primaryCrimson),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Issued: 10 Jan 2021', style: TextStyle(fontSize: 10, color: textSecondary)),
                                          Text('Valid: 09 Jan 2028', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textOnSurface)),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      const Row(
                                        children: [
                                          Icon(Icons.check_circle, size: 13, color: primaryCrimson),
                                          SizedBox(width: 4),
                                          Text(
                                            'Exceeds GCC 6-Month Work Visa Minimum Rule',
                                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: primaryCrimson),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Reminders Row
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'GCC Automated Expiry Reminders',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textOnSurface),
                              ),
                              Text(
                                'Push + WhatsApp',
                                style: TextStyle(fontSize: 10, color: textSecondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildReminderCheckbox('6 Months', _remind6Months, (v) => setState(() => _remind6Months = v ?? false)),
                              const SizedBox(width: 8),
                              _buildReminderCheckbox('3 Months', _remind3Months, (v) => setState(() => _remind3Months = v ?? false)),
                              const SizedBox(width: 8),
                              _buildReminderCheckbox('1 Month', _remind1Month, (v) => setState(() => _remind1Month = v ?? false)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Verified Bio-Page Document Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.document_scanner, size: 18, color: textSecondary),
                                  SizedBox(width: 8),
                                  Text(
                                    'Verified Bio-Page Document',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textOnSurface),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDEE2ED),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'MRZ Checksum OK',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF171C23)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: cardLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 55,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    color: cardHigh,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.assignment_ind, color: primaryCrimson, size: 30),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'passport_bio_n8492014.jpg',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textOnSurface),
                                      ),
                                      const Text(
                                        'Uploaded: 14 Oct 2023 • 2.4 MB',
                                        style: TextStyle(fontSize: 10, color: textSecondary),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: const Row(
                                              children: [
                                                Icon(Icons.visibility, size: 13, color: primaryCrimson),
                                                SizedBox(width: 3),
                                                Text('View Full PDF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryCrimson)),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          InkWell(
                                            onTap: () {},
                                            child: const Row(
                                              children: [
                                                Icon(Icons.download, size: 13, color: textSecondary),
                                                SizedBox(width: 3),
                                                Text('Export', style: TextStyle(fontSize: 10, color: textSecondary)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => context.push('/vault/passport-scan'),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      color: cardHigh,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Column(
                                      children: [
                                        Icon(Icons.qr_code_scanner, color: primaryCrimson, size: 22),
                                        SizedBox(height: 4),
                                        Text('Smart OCR Scan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textOnSurface)),
                                        Text('Auto-fill MRZ via Cam', style: TextStyle(fontSize: 9, color: textSecondary)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      color: cardHigh,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Column(
                                      children: [
                                        Icon(Icons.upload_file, color: textSecondary, size: 22),
                                        SizedBox(height: 4),
                                        Text('Upload New Scan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textOnSurface)),
                                        Text('PDF, JPG up to 10MB', style: TextStyle(fontSize: 9, color: textSecondary)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bio-Data Record Inputs
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.edit_document, size: 18, color: textSecondary),
                                  SizedBox(width: 8),
                                  Text(
                                    'Bio-Data Record Inputs',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textOnSurface),
                                  ),
                                ],
                              ),
                              Text(
                                'ICAO 9303 Compliant',
                                style: TextStyle(fontSize: 10, color: textSecondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Passport Number Field
                          _buildFieldLabel('PASSPORT NUMBER'),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _passportNoController,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: textOnSurface,
                                    ),
                                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                                  ),
                                ),
                                const Icon(Icons.edit, size: 16, color: primaryCrimson),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Legal Name Field
                          _buildFieldLabel('FULL LEGAL NAME (AS PRINTED ON BIO-PAGE)'),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: _nameController,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textOnSurface),
                              decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Nationality & Place of Issue
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel('NATIONALITY'),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('🇪🇬 Egyptian', style: TextStyle(fontSize: 12, color: textOnSurface)),
                                          Icon(Icons.expand_more, size: 16, color: textSecondary),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel('PLACE OF ISSUE'),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                                      child: TextField(
                                        controller: _placeOfIssueController,
                                        style: const TextStyle(fontSize: 12, color: textOnSurface),
                                        decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Date of Issue & Expiry
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel('DATE OF ISSUE'),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _issueDateController,
                                              style: const TextStyle(fontSize: 12, color: textOnSurface),
                                              decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                                            ),
                                          ),
                                          const Icon(Icons.calendar_today, size: 14, color: textSecondary),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel('DATE OF EXPIRY'),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _expiryDateController,
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textOnSurface),
                                              decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                                            ),
                                          ),
                                          const Icon(Icons.calendar_month, size: 14, color: primaryCrimson),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Archived Passports & Audit Trail
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => setState(() => _isHistoryExpanded = !_isHistoryExpanded),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.history_toggle_off, size: 18, color: textSecondary),
                                    SizedBox(width: 8),
                                    Text('Archived Passports & Audit Trail', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textOnSurface)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('1 Document', style: TextStyle(fontSize: 11, color: textSecondary)),
                                    Icon(_isHistoryExpanded ? Icons.expand_less : Icons.expand_more, size: 16, color: textSecondary),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (_isHistoryExpanded) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: cardLow,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.lock, size: 16, color: textSecondary),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Passport A1948201', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textOnSurface)),
                                        Text('Expired 2020 • Archived in Secure Vault', style: TextStyle(fontSize: 10, color: textSecondary)),
                                      ],
                                    ),
                                  ),
                                  Text('View', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryCrimson)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Compliance footnote
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified, size: 12, color: primaryCrimson),
                        SizedBox(width: 5),
                        Text(
                          'Encrypted End-to-End • Conforms to Saudi KSA & UAE Data Residence',
                          style: TextStyle(fontSize: 9, color: textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Action Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: cardLowest,
                boxShadow: [
                  BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, -2)),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Passport details saved and synced with active pipeline!')),
                        );
                        context.pop();
                      },
                      icon: const Icon(Icons.check_circle, size: 18, color: Colors.white),
                      label: const Text(
                        'Save Passport Updates',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryCrimson,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: TextButton(
                      onPressed: () => context.pop(),
                      style: TextButton.styleFrom(
                        backgroundColor: cardLow,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Cancel / Keep Current Passport',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary),
                      ),
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

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.bold,
        color: Color(0xFF5A5F67),
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildReminderCheckbox(String title, bool isChecked, ValueChanged<bool?> onChanged) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3FD),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF181C23)),
            ),
            Transform.scale(
              scale: 0.8,
              child: Checkbox(
                value: isChecked,
                activeColor: const Color(0xFF6E0000),
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

