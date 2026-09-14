import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/features/profile/providers/profile_provider.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';
import 'package:mena_recruitment/features/vault/providers/vault_provider.dart';

class MedicalClearanceScreen extends ConsumerStatefulWidget {
  const MedicalClearanceScreen({super.key});

  @override
  ConsumerState<MedicalClearanceScreen> createState() => _MedicalClearanceScreenState();
}

class _MedicalClearanceScreenState extends ConsumerState<MedicalClearanceScreen> {
  final TextEditingController _centerNameController = TextEditingController();
  final TextEditingController _slipNumberController = TextEditingController();
  final TextEditingController _examDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  String _selectedCountry = 'Saudi Arabia (KSA)';
  String _fitnessStatus = 'Fit for GCC Employment';
  DateTime? _examDate;
  DateTime? _expiryDate;

  PlatformFile? _attachedFile;
  String? _attachedFileName;

  final List<String> _gccCountries = [
    'Saudi Arabia (KSA)',
    'United Arab Emirates (UAE)',
    'Qatar',
    'Kuwait',
    'Oman',
    'Bahrain',
  ];

  final List<String> _fitnessOptions = [
    'Fit for GCC Employment',
    'Fit with Conditions',
    'Pending Lab Confirmation',
  ];

  @override
  void initState() {
    super.initState();
    final docs = ref.read(vaultDocumentsProvider).valueOrNull ?? [];
    final existingGamca = docs.where((d) => d.category == DocumentCategory.medicalGamca).firstOrNull;

    if (existingGamca != null) {
      _centerNameController.text = existingGamca.title;
      _slipNumberController.text = existingGamca.documentNumber;
      if (existingGamca.issuingCountry.isNotEmpty) {
        final match = _gccCountries.firstWhere(
          (c) => c.toLowerCase().contains(existingGamca.issuingCountry.toLowerCase()),
          orElse: () => _gccCountries.first,
        );
        _selectedCountry = match;
      }
      _expiryDate = existingGamca.expiryDate;
      if (_expiryDate != null) {
        _expiryDateController.text = _formatDate(_expiryDate!);
      }
      if (existingGamca.fileUrl != null && existingGamca.fileUrl!.isNotEmpty) {
        _attachedFileName = existingGamca.fileUrl;
      }
    } else {
      final profile = ref.read(profileProvider).valueOrNull;
      if (profile != null && profile.preferredCountries.isNotEmpty) {
        final target = profile.preferredCountries.first;
        final match = _gccCountries.firstWhere(
          (c) => c.toLowerCase().contains(target.toLowerCase()),
          orElse: () => _gccCountries.first,
        );
        _selectedCountry = match;
      }
    }
  }

  @override
  void dispose() {
    _centerNameController.dispose();
    _slipNumberController.dispose();
    _examDateController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _pickDate({required bool isExpiry}) async {
    final now = DateTime.now();
    final initial = isExpiry
        ? (_expiryDate ?? now.add(const Duration(days: 90)))
        : (_examDate ?? now);
    final firstDate = isExpiry ? now.subtract(const Duration(days: 30)) : DateTime(2020);
    final lastDate = DateTime(2035);

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
      setState(() {
        if (isExpiry) {
          _expiryDate = picked;
          _expiryDateController.text = _formatDate(picked);
        } else {
          _examDate = picked;
          _examDateController.text = _formatDate(picked);
          // GAMCA reports typically valid for 3 months (90 days) from test date
          if (_expiryDate == null) {
            _expiryDate = picked.add(const Duration(days: 90));
            _expiryDateController.text = _formatDate(_expiryDate!);
          }
        }
      });
    }
  }

  Future<void> _pickMedicalDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      setState(() {
        _attachedFile = file;
        _attachedFileName = file.name;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not attach file: $e'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    }
  }

  Future<void> _saveMedicalReport() async {
    final centerName = _centerNameController.text.trim();
    final slipNo = _slipNumberController.text.trim();

    if (centerName.isEmpty && slipNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least the Medical Center name or GCC Slip number.'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    final isFit = _fitnessStatus == 'Fit for GCC Employment';
    final docTitle = centerName.isNotEmpty ? centerName : 'GAMCA Medical Report ($slipNo)';
    final docNumber = slipNo.isNotEmpty ? slipNo : 'GCC-MED-${DateTime.now().millisecondsSinceEpoch % 100000}';
    final exp = _expiryDate ?? DateTime.now().add(const Duration(days: 90));

    final doc = VaultDocument(
      id: 'doc-gamca-${DateTime.now().millisecondsSinceEpoch}',
      category: DocumentCategory.medicalGamca,
      title: docTitle,
      documentNumber: docNumber,
      issuingCountry: _selectedCountry,
      expiryDate: exp,
      isValidForGccVisa: isFit,
      isVerified: isFit,
      fileUrl: _attachedFileName ?? (_attachedFile != null ? _attachedFile!.name : 'medical_clearance.pdf'),
      reminder6Months: false,
      reminder3Months: true,
    );

    await ref.read(vaultRepositoryProvider).addDocument(doc);
    ref.invalidate(vaultDocumentsProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ GAMCA Medical Clearance report saved successfully!'),
          backgroundColor: Color(0xFF059669),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryCrimson = Color(0xFF6E0000);
    const lightSurface = Color(0xFFF9F9FF);
    const cardLowest = Colors.white;
    const cardLow = Color(0xFFF1F3FD);
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
              child: Row(
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
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GAMCA Medical Clearance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textOnSurface,
                          ),
                        ),
                        Text(
                          'WAFID / GCC Approved Center Report',
                          style: TextStyle(fontSize: 11, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.health_and_safety, size: 14, color: Color(0xFF16A34A)),
                        SizedBox(width: 4),
                        Text(
                          'GCC Visa',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E8F2)),

            // Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Regulatory Information Banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFEDD5)),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: Color(0xFFEA580C), size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'GCC Work Visa Requirement',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF9A3412),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Medical clearance must be obtained through a GAMCA / Wafid authorized diagnostic center for Saudi Arabia, UAE, Qatar, Kuwait, Oman, or Bahrain visa stamping.',
                                  style: TextStyle(fontSize: 11, color: Color(0xFFC2410C), height: 1.35),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Medical Report Details Card
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
                            children: [
                              Icon(Icons.local_hospital_outlined, size: 18, color: primaryCrimson),
                              SizedBox(width: 8),
                              Text(
                                'Report Information',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textOnSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Medical Center Name
                          _buildLabel('APPROVED MEDICAL CENTER NAME'),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                            decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: _centerNameController,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textOnSurface),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: 'e.g. Wafid Health Center / Al-Bayan Diagnostics',
                                hintStyle: TextStyle(fontSize: 12, color: textSecondary),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // GCC Slip / Registration No
                          _buildLabel('GCC SLIP / WAFID REGISTRATION NUMBER'),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                            decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: _slipNumberController,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: textOnSurface),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: 'e.g. GCC-2025-998124',
                                hintStyle: TextStyle(fontSize: 12, color: textSecondary),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Target GCC Country Dropdown
                          _buildLabel('DESTINATION GCC COUNTRY'),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCountry,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down, color: textSecondary),
                                items: _gccCountries.map((country) {
                                  return DropdownMenuItem<String>(
                                    value: country,
                                    child: Text(
                                      country,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textOnSurface),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedCountry = val);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Fitness Classification
                          _buildLabel('FITNESS EVALUATION STATUS'),
                          const SizedBox(height: 6),
                          Column(
                            children: _fitnessOptions.map((status) {
                              final isSelected = _fitnessStatus == status;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: InkWell(
                                  onTap: () => setState(() => _fitnessStatus = status),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFFFDF2F2) : cardLow,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected ? primaryCrimson : Colors.transparent,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                          size: 16,
                                          color: isSelected ? primaryCrimson : textSecondary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          status,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                            color: isSelected ? primaryCrimson : textOnSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),

                          // Test Date & Expiry Date Pickers
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('EXAMINATION DATE'),
                                    const SizedBox(height: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _examDateController,
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
                                    _buildLabel('EXPIRY DATE'),
                                    const SizedBox(height: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

                    // Document Upload / Attachment Card
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
                                  Icon(Icons.attachment, size: 18, color: primaryCrimson),
                                  SizedBox(width: 8),
                                  Text(
                                    'Medical Certificate File',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textOnSurface,
                                    ),
                                  ),
                                ],
                              ),
                              Text('PDF, JPG, PNG', style: TextStyle(fontSize: 10, color: textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 12),

                          if (_attachedFileName != null) ...[
                            // Attached file preview
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: cardLow,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFD1D5DB)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEE2E2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.picture_as_pdf, color: primaryCrimson, size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _attachedFileName!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textOnSurface),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _attachedFile != null
                                              ? '${(_attachedFile!.size / 1024).toStringAsFixed(0)} KB • Attached'
                                              : 'Saved in Vault',
                                          style: const TextStyle(fontSize: 10, color: textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 18, color: textSecondary),
                                    onPressed: () {
                                      setState(() {
                                        _attachedFile = null;
                                        _attachedFileName = null;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: _pickMedicalDocument,
                                icon: const Icon(Icons.refresh, size: 14, color: primaryCrimson),
                                label: const Text('Replace File', style: TextStyle(fontSize: 11, color: primaryCrimson, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ] else ...[
                            // Upload Dropzone
                            InkWell(
                              onTap: _pickMedicalDocument,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: cardLow,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.upload_file, size: 28, color: primaryCrimson),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Upload Medical Clearance Certificate',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textOnSurface),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Attach scanned report or WAFID clearance slip (Max 10MB)',
                                      style: TextStyle(fontSize: 11, color: textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Save Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: cardLowest,
                boxShadow: [
                  BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, -2)),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _saveMedicalReport,
                  icon: const Icon(Icons.check_circle, size: 18, color: Colors.white),
                  label: const Text(
                    'Save Medical Clearance',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryCrimson,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
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
}
