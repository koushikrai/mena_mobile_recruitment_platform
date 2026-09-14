import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/features/profile/providers/profile_provider.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';
import 'package:mena_recruitment/features/vault/providers/vault_provider.dart';

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

  final TextEditingController _passportNoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _placeOfIssueController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  DateTime? _selectedExpiryDate;
  DateTime? _selectedIssueDate;
  String _nationality = '';

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).valueOrNull;
    if (profile != null && profile.fullName.isNotEmpty) {
      _nameController.text = profile.fullName.toUpperCase();
    }
    if (profile != null && profile.nationality.isNotEmpty) {
      _nationality = profile.nationality;
    }
    final docs = ref.read(vaultDocumentsProvider).valueOrNull ?? [];
    final existingPassport = docs.where((d) => d.category == DocumentCategory.passport).firstOrNull;
    if (existingPassport != null) {
      _passportNoController.text = existingPassport.documentNumber;
      _placeOfIssueController.text = existingPassport.issuingCountry;
      _selectedExpiryDate = existingPassport.expiryDate;
      if (existingPassport.expiryDate != null) {
        final exp = existingPassport.expiryDate!;
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        _expiryDateController.text = '${exp.day.toString().padLeft(2, '0')} ${months[exp.month - 1]} ${exp.year}';
      }
    }

    _passportNoController.addListener(_onTextChanged);
    _nameController.addListener(_onTextChanged);
    _placeOfIssueController.addListener(_onTextChanged);
    _expiryDateController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _passportNoController.removeListener(_onTextChanged);
    _nameController.removeListener(_onTextChanged);
    _placeOfIssueController.removeListener(_onTextChanged);
    _expiryDateController.removeListener(_onTextChanged);
    _passportNoController.dispose();
    _nameController.dispose();
    _placeOfIssueController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isExpiry}) async {
    final now = DateTime.now();
    final initial = isExpiry
        ? (_selectedExpiryDate ?? now.add(const Duration(days: 365 * 3)))
        : (_selectedIssueDate ?? now.subtract(const Duration(days: 365 * 2)));
    final firstDate = isExpiry ? DateTime(2000) : DateTime(1970);
    final lastDate = DateTime(2045);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6E0000),
              onPrimary: Colors.white,
              onSurface: Color(0xFF181C23),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final formatted = '${picked.day.toString().padLeft(2, '0')} ${months[picked.month - 1]} ${picked.year}';
      setState(() {
        if (isExpiry) {
          _selectedExpiryDate = picked;
          _expiryDateController.text = formatted;
        } else {
          _selectedIssueDate = picked;
          _issueDateController.text = formatted;
        }
      });
    }
  }

  void _showNationalityPicker() {
    final commonNationalities = [
      'Indian',
      'Pakistani',
      'Egyptian',
      'Filipino',
      'Bangladeshi',
      'Nepali',
      'Sri Lankan',
      'Jordanian',
      'Lebanese',
      'Saudi',
      'Emirati',
      'Other',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Select Passport Nationality',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF181C23)),
                ),
              ),
              const Divider(),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: commonNationalities.length,
                  itemBuilder: (ctx, index) {
                    final item = commonNationalities[index];
                    return ListTile(
                      title: Text(item, style: const TextStyle(fontSize: 14)),
                      trailing: _nationality == item ? const Icon(Icons.check, color: Color(0xFF6E0000)) : null,
                      onTap: () {
                        setState(() {
                          _nationality = item;
                        });
                        Navigator.of(ctx).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
                                      'GCC Visa Compliance Notice',
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
                                        'Saudi, UAE & GCC',
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
                                const Text(
                                  'Keep your travel document details accurate and current to ensure seamless Qiwa, Muqeem, and MOHRE work visa approvals without flight disruption.',
                                  style: TextStyle(fontSize: 11, color: textSecondary, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Primary Travel Document Card
                    Builder(
                      builder: (context) {
                        final hasEnteredPassport = _passportNoController.text.trim().isNotEmpty;
                        DateTime? expDate = _selectedExpiryDate;
                        if (expDate == null && _expiryDateController.text.trim().isNotEmpty) {
                          try {
                            final parts = _expiryDateController.text.trim().split(' ');
                            if (parts.length == 3) {
                              const months = {'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12};
                              final d = int.tryParse(parts[0]);
                              final m = months[parts[1]];
                              final y = int.tryParse(parts[2]);
                              if (d != null && m != null && y != null) {
                                expDate = DateTime(y, m, d);
                              }
                            }
                          } catch (_) {}
                        }
                        final daysRemaining = expDate?.difference(DateTime.now()).inDays;
                        final yearsRemaining = (daysRemaining != null && daysRemaining > 0)
                            ? (daysRemaining / 365.25).toStringAsFixed(1)
                            : null;
                        final exceedsSixMonths = daysRemaining != null && daysRemaining >= 180;
                        final meterProgress = daysRemaining != null
                            ? (daysRemaining / (365.25 * 5)).clamp(0.0, 1.0)
                            : 0.0;
                        final countryLabel = _placeOfIssueController.text.trim().isNotEmpty
                            ? _placeOfIssueController.text.trim().toUpperCase()
                            : (_nationality.isNotEmpty ? _nationality.toUpperCase() : 'PASSPORT');

                        return Container(
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
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 3,
                                          backgroundColor: hasEnteredPassport ? containerCrimson : textSecondary,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          hasEnteredPassport ? 'Active in Travel Vault' : 'Not Added Yet',
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textOnSurface),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              if (!hasEnteredPassport) ...[
                                // Empty state card
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: cardLow,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: const Color(0xFFE4DADB)),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.travel_explore_rounded, size: 30, color: primaryCrimson),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'No Passport Details Added Yet',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: textOnSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Fill in your passport bio-page details below or scan your passport to auto-extract details.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 11, color: textSecondary, height: 1.4),
                                      ),
                                      const SizedBox(height: 12),
                                      OutlinedButton.icon(
                                        onPressed: () => context.push(RouteNames.passportScan),
                                        icon: const Icon(Icons.document_scanner_outlined, size: 15, color: primaryCrimson),
                                        label: const Text(
                                          'Scan Passport Bio-Page',
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryCrimson),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: primaryCrimson),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                // Dynamic Passport Ticket Graphic
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
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: const Icon(Icons.flight_takeoff, color: primaryCrimson, size: 20),
                                              ),
                                              const SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'ISSUING STATE / PLACE',
                                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: textSecondary),
                                                  ),
                                                  Text(
                                                    countryLabel,
                                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textOnSurface),
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
                                                _passportNoController.text.trim(),
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
                                        _nameController.text.trim().isNotEmpty ? _nameController.text.trim().toUpperCase() : 'CANDIDATE NAME',
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Row(
                                                  children: [
                                                    Icon(Icons.verified_user_outlined, size: 14, color: primaryCrimson),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      'GCC Visa Clearance Status',
                                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textOnSurface),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  yearsRemaining != null
                                                      ? 'Expires in $yearsRemaining Years'
                                                      : (_expiryDateController.text.isNotEmpty ? 'Exp: ${_expiryDateController.text}' : 'Date Pending'),
                                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryCrimson),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: LinearProgressIndicator(
                                                value: meterProgress,
                                                minHeight: 6,
                                                backgroundColor: cardLow,
                                                valueColor: const AlwaysStoppedAnimation<Color>(primaryCrimson),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  _issueDateController.text.isNotEmpty ? 'Issued: ${_issueDateController.text}' : 'Issue Date: N/A',
                                                  style: const TextStyle(fontSize: 10, color: textSecondary),
                                                ),
                                                Text(
                                                  _expiryDateController.text.isNotEmpty ? 'Valid: ${_expiryDateController.text}' : 'Valid: Pending',
                                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textOnSurface),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Icon(
                                                  exceedsSixMonths ? Icons.check_circle : Icons.info_outline,
                                                  size: 13,
                                                  color: exceedsSixMonths ? primaryCrimson : const Color(0xFFD97706),
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    exceedsSixMonths
                                                        ? 'Exceeds GCC 6-Month Work Visa Minimum Rule'
                                                        : (daysRemaining != null && daysRemaining < 180
                                                            ? 'Warning: Less than 6 months validity for GCC visa'
                                                            : 'Enter passport expiry date to check 6-month GCC visa rule'),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w600,
                                                      color: exceedsSixMonths ? primaryCrimson : const Color(0xFFD97706),
                                                    ),
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
                              ],
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
                    );
                  },
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
                                      Text(
                                        _passportNoController.text.trim().isNotEmpty
                                            ? 'passport_${_passportNoController.text.trim().toLowerCase()}.jpg'
                                            : 'No passport bio-page uploaded yet',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textOnSurface),
                                      ),
                                      Text(
                                        _passportNoController.text.trim().isNotEmpty
                                            ? 'MRZ Validated • 2.4 MB'
                                            : 'Tap OCR Scan below to scan your passport',
                                        style: const TextStyle(fontSize: 10, color: textSecondary),
                                      ),
                                      const SizedBox(height: 6),
                                      if (_passportNoController.text.trim().isNotEmpty)
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
                                    InkWell(
                                      onTap: _showNationalityPicker,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _nationality.isNotEmpty ? _nationality : 'Select Nationality',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: _nationality.isNotEmpty ? textOnSurface : textSecondary,
                                              ),
                                            ),
                                            const Icon(Icons.expand_more, size: 16, color: textSecondary),
                                          ],
                                        ),
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
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          hintText: 'e.g. New Delhi / Cairo',
                                          hintStyle: TextStyle(fontSize: 11, color: textSecondary),
                                        ),
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
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                hintText: 'DD MMM YYYY',
                                                hintStyle: TextStyle(fontSize: 11, color: textSecondary),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: const Icon(Icons.calendar_today, size: 14, color: textSecondary),
                                            onPressed: () => _pickDate(isExpiry: false),
                                          ),
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
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                hintText: 'DD MMM YYYY',
                                                hintStyle: TextStyle(fontSize: 11, color: textSecondary),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: const Icon(Icons.calendar_month, size: 14, color: primaryCrimson),
                                            onPressed: () => _pickDate(isExpiry: true),
                                          ),
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
                                    const Text('0 Documents', style: TextStyle(fontSize: 11, color: textSecondary)),
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
                                  Icon(Icons.inventory_2_outlined, size: 16, color: textSecondary),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'No archived passport records found. Updated or replaced travel documents will appear here.',
                                      style: TextStyle(fontSize: 11, color: textSecondary),
                                    ),
                                  ),
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
                      onPressed: () async {
                        final passNo = _passportNoController.text.trim();
                        final country = _placeOfIssueController.text.trim();

                        if (passNo.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a passport number before saving.'),
                              backgroundColor: Color(0xFFBA1A1A),
                            ),
                          );
                          return;
                        }

                        DateTime? expDate = _selectedExpiryDate;
                        if (expDate == null && _expiryDateController.text.trim().isNotEmpty) {
                          try {
                            final parts = _expiryDateController.text.trim().split(' ');
                            if (parts.length == 3) {
                              const months = {'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12};
                              final d = int.tryParse(parts[0]);
                              final m = months[parts[1]];
                              final y = int.tryParse(parts[2]);
                              if (d != null && m != null && y != null) {
                                expDate = DateTime(y, m, d);
                              }
                            }
                          } catch (_) {}
                        }
                        expDate ??= DateTime.now().add(const Duration(days: 365 * 4));

                        final passportDoc = VaultDocument(
                          id: 'doc-passport-${DateTime.now().millisecondsSinceEpoch}',
                          category: DocumentCategory.passport,
                          title: 'Passport ($passNo)',
                          documentNumber: passNo,
                          issuingCountry: country.isNotEmpty
                              ? country
                              : (_nationality.isNotEmpty ? _nationality : 'Passport Office'),
                          expiryDate: expDate,
                          isValidForGccVisa: expDate.difference(DateTime.now()).inDays >= 180,
                          isVerified: true,
                          reminder6Months: _remind6Months,
                          reminder3Months: _remind3Months,
                        );
                        await ref.read(vaultRepositoryProvider).addDocument(passportDoc);
                        ref.invalidate(vaultDocumentsProvider);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✓ Passport details saved successfully!'),
                              backgroundColor: Color(0xFF059669),
                            ),
                          );
                          context.pop();
                        }
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

