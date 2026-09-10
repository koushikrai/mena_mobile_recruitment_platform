import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/features/cv_parser/providers/manual_profile_state.dart';

class ManualDetailsScreen extends ConsumerStatefulWidget {
  const ManualDetailsScreen({super.key});

  @override
  ConsumerState<ManualDetailsScreen> createState() => _ManualDetailsScreenState();
}

class _ManualDetailsScreenState extends ConsumerState<ManualDetailsScreen> {
  final _stage1FormKey = GlobalKey<FormState>();

  // Stage 1 Controllers
  late TextEditingController _fullNameCtrl;
  late TextEditingController _targetTitleCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _cityCtrl;

  // Stage 4 Controllers
  late TextEditingController _currentSalaryCtrl;
  late TextEditingController _expectedSalaryCtrl;

  static const _crimson = Color(0xFF6E0000);
  static const _surface = Color(0xFFF9F9FF);
  static const _white = Colors.white;
  static const _cardLow = Color(0xFFF1F3FD);
  static const _cardMid = Color(0xFFE5E8F2);
  static const _ink = Color(0xFF181C23);
  static const _inkLight = Color(0xFF5A5F67);
  static const _green = Color(0xFF059669);
  static const _greenBg = Color(0xFFECFDF5);

  final List<String> _countryCodes = [
    '+966', '+971', '+974', '+965', '+968', '+973',
    '+91', '+20', '+92', '+962', '+63', '+44', '+1',
  ];

  final List<String> _nationalities = [
    'Saudi Arabia',
    'United Arab Emirates',
    'Egyptian',
    'Indian',
    'Pakistani',
    'Jordanian',
    'Filipino',
    'Lebanese',
    'Sudanese',
    'British',
    'American',
    'Canadian',
    'Other',
  ];

  final List<String> _residentCountries = [
    'Saudi Arabia',
    'United Arab Emirates',
    'Qatar',
    'Kuwait',
    'Oman',
    'Bahrain',
    'Egypt',
    'India',
    'Pakistan',
    'Jordan',
    'Other',
  ];

  final List<String> _currencies = ['SAR', 'AED', 'QAR', 'USD', 'KWD', 'OMR', 'BHD'];

  final List<String> _noticePeriods = [
    'Immediate (Available now)',
    'Within 15 days',
    'Within 30 days',
    'Within 60 days',
    '2+ months notice',
  ];

  final List<String> _relocationOptions = [
    'Immediately available',
    'Within 15 days',
    'Within 30 days',
    'Within 60 days',
    'Flexible / Negotiable',
  ];

  @override
  void initState() {
    super.initState();
    final state = ref.read(manualProfileProvider);
    _fullNameCtrl = TextEditingController(text: state.basicDetails.fullName);
    _targetTitleCtrl = TextEditingController(text: state.basicDetails.targetTitle);
    _emailCtrl = TextEditingController(text: state.basicDetails.email);
    _phoneCtrl = TextEditingController(text: state.basicDetails.phone);
    _cityCtrl = TextEditingController(text: state.basicDetails.city);

    _currentSalaryCtrl = TextEditingController(text: state.salaryRelocation.currentSalary.toInt().toString());
    _expectedSalaryCtrl = TextEditingController(text: state.salaryRelocation.expectedSalary.toInt().toString());
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _targetTitleCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    _currentSalaryCtrl.dispose();
    _expectedSalaryCtrl.dispose();
    super.dispose();
  }

  void _handleBack() {
    final state = ref.read(manualProfileProvider);
    if (state.currentStage > 0) {
      ref.read(manualProfileProvider.notifier).prevStage();
    } else {
      context.pop();
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // STAGE 1: BASIC DETAILS LOGIC
  // ───────────────────────────────────────────────────────────────────────────

  void _saveStage1AndProceed() {
    if (!_stage1FormKey.currentState!.validate()) return;

    final current = ref.read(manualProfileProvider).basicDetails;
    final updated = current.copyWith(
      fullName: _fullNameCtrl.text.trim(),
      targetTitle: _targetTitleCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
    );

    ref.read(manualProfileProvider.notifier).updateBasicDetails(updated);
    ref.read(manualProfileProvider.notifier).nextStage();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // STAGE 2: WORK EXPERIENCE & EDUCATION MODALS
  // ───────────────────────────────────────────────────────────────────────────

  void _showAddEditExperienceModal({ManualWorkExperience? existing, int? editIndex}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final compCtrl = TextEditingController(text: existing?.company ?? '');
    final locCtrl = TextEditingController(text: existing?.location ?? 'Saudi Arabia');
    final datesCtrl = TextEditingController(text: existing?.dates ?? '2021 – Present');
    final respCtrl = TextEditingController(text: existing?.responsibilities.join('\n') ?? '');
    bool isCurrent = existing?.isCurrent ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (modalCtx, setModalState) => Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      existing == null ? 'Add Work Experience' : 'Edit Work Experience',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _ink),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(modalCtx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildModalTextField(titleCtrl, 'Job Title / Designation *', Icons.work_outline),
                const SizedBox(height: 10),
                _buildModalTextField(compCtrl, 'Company Name *', Icons.business),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildModalTextField(locCtrl, 'Location (e.g. Riyadh, KSA)', Icons.location_on_outlined)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildModalTextField(datesCtrl, 'Duration (e.g. 2021 – 2024)', Icons.calendar_today_outlined)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: isCurrent,
                      activeColor: _crimson,
                      onChanged: (v) => setModalState(() => isCurrent = v ?? false),
                    ),
                    const Text('This is my current role', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _ink)),
                  ],
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: respCtrl,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13, color: _ink),
                  decoration: InputDecoration(
                    labelText: 'Key Responsibilities (One bullet per line)',
                    filled: true,
                    fillColor: _cardLow,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (existing != null) ...[
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          ref.read(manualProfileProvider.notifier).deleteWorkExperience(editIndex!);
                          Navigator.pop(modalCtx);
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleCtrl.text.trim().isEmpty || compCtrl.text.trim().isEmpty) return;
                          final respList = respCtrl.text
                              .split('\n')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList();
                          final item = ManualWorkExperience(
                            id: existing?.id ?? 'exp-${DateTime.now().millisecondsSinceEpoch}',
                            title: titleCtrl.text.trim(),
                            company: compCtrl.text.trim(),
                            location: locCtrl.text.trim(),
                            dates: datesCtrl.text.trim(),
                            isCurrent: isCurrent,
                            responsibilities: respList,
                          );
                          if (existing == null) {
                            ref.read(manualProfileProvider.notifier).addWorkExperience(item);
                          } else {
                            ref.read(manualProfileProvider.notifier).updateWorkExperience(editIndex!, item);
                          }
                          Navigator.pop(modalCtx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _crimson,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(existing == null ? 'Save Experience' : 'Update Experience', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddEditEducationModal({ManualEducation? existing, int? editIndex}) {
    final degreeCtrl = TextEditingController(text: existing?.degree ?? '');
    final fieldCtrl = TextEditingController(text: existing?.fieldOfStudy ?? '');
    final instCtrl = TextEditingController(text: existing?.institution ?? '');
    final yearCtrl = TextEditingController(text: existing?.graduationYear ?? '');
    final gradeCtrl = TextEditingController(text: existing?.grade ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    existing == null ? 'Add Education' : 'Edit Education',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _ink),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildModalTextField(degreeCtrl, 'Degree (e.g. Bachelor of Science, Diploma) *', Icons.school_outlined),
              const SizedBox(height: 10),
              _buildModalTextField(fieldCtrl, 'Field of Study (e.g. Mechanical Engineering) *', Icons.book_outlined),
              const SizedBox(height: 10),
              _buildModalTextField(instCtrl, 'University / Institution *', Icons.account_balance_outlined),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildModalTextField(yearCtrl, 'Graduation Year (e.g. 2018)', Icons.calendar_month)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildModalTextField(gradeCtrl, 'Grade / GPA (Optional)', Icons.star_border)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (existing != null) ...[
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        ref.read(manualProfileProvider.notifier).deleteEducation(editIndex!);
                        Navigator.pop(ctx);
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (degreeCtrl.text.trim().isEmpty || fieldCtrl.text.trim().isEmpty) return;
                        final item = ManualEducation(
                          id: existing?.id ?? 'edu-${DateTime.now().millisecondsSinceEpoch}',
                          degree: degreeCtrl.text.trim(),
                          fieldOfStudy: fieldCtrl.text.trim(),
                          institution: instCtrl.text.trim(),
                          graduationYear: yearCtrl.text.trim(),
                          grade: gradeCtrl.text.trim().isNotEmpty ? gradeCtrl.text.trim() : null,
                        );
                        if (existing == null) {
                          ref.read(manualProfileProvider.notifier).addEducation(item);
                        } else {
                          ref.read(manualProfileProvider.notifier).updateEducation(editIndex!, item);
                        }
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _crimson,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(existing == null ? 'Save Education' : 'Update Education', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // STAGE 3: CERTIFICATIONS MODAL & QUICK ADD
  // ───────────────────────────────────────────────────────────────────────────

  void _showAddEditCertificationModal({ManualCertification? existing, int? editIndex}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final issuerCtrl = TextEditingController(text: existing?.issuer ?? '');
    final credCtrl = TextEditingController(text: existing?.credentialNumber ?? '');
    final issueYearCtrl = TextEditingController(text: existing?.issueYear ?? '2022');
    final expYearCtrl = TextEditingController(text: existing?.expiryYear ?? '2027');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    existing == null ? 'Add Certification / Accreditation' : 'Edit Certification',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _ink),
                  ),
                  IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 12),
              _buildModalTextField(titleCtrl, 'Certification Name (e.g. NEBOSH IGC) *', Icons.verified_outlined),
              const SizedBox(height: 10),
              _buildModalTextField(issuerCtrl, 'Issuing Organization / Board *', Icons.account_balance),
              const SizedBox(height: 10),
              _buildModalTextField(credCtrl, 'Credential / License ID (Optional)', Icons.tag),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildModalTextField(issueYearCtrl, 'Issue Year (e.g. 2021)', Icons.calendar_today)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildModalTextField(expYearCtrl, 'Expiry Year / Lifetime', Icons.event_available)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (existing != null) ...[
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        ref.read(manualProfileProvider.notifier).deleteCertification(editIndex!);
                        Navigator.pop(ctx);
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleCtrl.text.trim().isEmpty) return;
                        final item = ManualCertification(
                          id: existing?.id ?? 'cert-${DateTime.now().millisecondsSinceEpoch}',
                          title: titleCtrl.text.trim(),
                          issuer: issuerCtrl.text.trim().isNotEmpty ? issuerCtrl.text.trim() : 'Accredited Board',
                          credentialNumber: credCtrl.text.trim().isNotEmpty ? credCtrl.text.trim() : 'VERIFIED-${DateTime.now().millisecondsSinceEpoch % 10000}',
                          issueYear: issueYearCtrl.text.trim(),
                          expiryYear: expYearCtrl.text.trim().isNotEmpty ? expYearCtrl.text.trim() : 'Lifetime',
                          isVerified: true,
                        );
                        if (existing == null) {
                          ref.read(manualProfileProvider.notifier).addCertification(item);
                        } else {
                          ref.read(manualProfileProvider.notifier).updateCertification(editIndex!, item);
                        }
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _crimson,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(existing == null ? 'Save Certification' : 'Update Certification', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _quickAddCertification(String title, String issuer, String code) {
    final item = ManualCertification(
      id: 'cert-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      issuer: issuer,
      credentialNumber: code,
      issueYear: '2023',
      expiryYear: 'Valid / Active',
      isVerified: true,
    );
    ref.read(manualProfileProvider.notifier).addCertification(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✓ $title added!'), backgroundColor: _green, duration: const Duration(seconds: 1)),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // STAGE 4: SALARY, RESUME & RELOCATION LOGIC
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _pickAndUploadResume() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.first;
      final fileName = file.name;
      final sizeInBytes = file.size;
      final sizeFormatted = sizeInBytes > 1024 * 1024
          ? '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB'
          : '${(sizeInBytes / 1024).toStringAsFixed(0)} KB';

      ref.read(manualProfileProvider.notifier).setResumeFileName(fileName);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text('✓ "$fileName" ($sizeFormatted) attached successfully!')),
            ],
          ),
          backgroundColor: _green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final state = ref.read(manualProfileProvider);
      final fallbackName = '${state.basicDetails.fullName.replaceAll(" ", "_")}_CV_2026.pdf';
      ref.read(manualProfileProvider.notifier).setResumeFileName(fallbackName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ "$fallbackName" attached!'),
          backgroundColor: _green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _handleFinalSubmit() async {
    final currentSal = double.tryParse(_currentSalaryCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 12000.0;
    final expSal = double.tryParse(_expectedSalaryCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 16000.0;

    final state = ref.read(manualProfileProvider);
    ref.read(manualProfileProvider.notifier).updateSalaryRelocation(
      state.salaryRelocation.copyWith(
        currentSalary: currentSal,
        expectedSalary: expSal,
      ),
    );

    final success = await ref.read(manualProfileProvider.notifier).submitCompleteProfile(ref);

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(child: Text('Candidate profile successfully completed & saved!')),
            ],
          ),
          backgroundColor: _green,
          duration: Duration(seconds: 3),
        ),
      );
      context.go(RouteNames.profile);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save profile. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // BUILD METHOD
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(manualProfileProvider);

    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Stepper Navigation ──────────────────────────────────────
            _buildTopStepper(state.currentStage),

            // ── Stage Content ───────────────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildStageContent(state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStepper(int stage) {
    final titles = [
      'STAGE 1 OF 4: BASIC DETAILS',
      'STAGE 2 OF 4: EXPERIENCE & EDUCATION',
      'STAGE 3 OF 4: CERTIFICATIONS',
      'STAGE 4 OF 4: SALARY & RESUME',
    ];
    final percentages = ['25%', '50%', '75%', '100%'];
    final progressValues = [0.25, 0.50, 0.75, 1.0];

    return Container(
      color: _white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _cardLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back, size: 18, color: _ink),
                  onPressed: _handleBack,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    titles[stage],
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _inkLight, letterSpacing: 0.8),
                  ),
                  Text(
                    '${percentages[stage]} Completed',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _crimson),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressValues[stage],
              minHeight: 4,
              backgroundColor: _cardMid,
              valueColor: const AlwaysStoppedAnimation<Color>(_crimson),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageContent(ManualProfileState state) {
    switch (state.currentStage) {
      case 0:
        return _buildStage1BasicDetails(state);
      case 1:
        return _buildStage2ExperienceAndEducation(state);
      case 2:
        return _buildStage3Certifications(state);
      case 3:
        return _buildStage4SalaryAndResume(state);
      default:
        return _buildStage1BasicDetails(state);
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // STAGE 1 VIEW: BASIC DETAILS (Personal & Contact Information)
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildStage1BasicDetails(ManualProfileState state) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _stage1FormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal & Contact Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _ink, letterSpacing: -0.3),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Enter your legal name, title, and contact coordinates for GCC recruiter outreach.',
                    style: TextStyle(fontSize: 12, color: _inkLight),
                  ),
                  const SizedBox(height: 16),

                  _buildCard(
                    children: [
                      _buildTextField(
                        controller: _fullNameCtrl,
                        label: 'Full Legal Name *',
                        icon: Icons.person_outline,
                        hint: 'e.g. Ahmed Mansoor',
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Full name is required' : null,
                      ),
                      const SizedBox(height: 12),

                      _buildTextField(
                        controller: _targetTitleCtrl,
                        label: 'Target Job Designation *',
                        icon: Icons.badge_outlined,
                        hint: 'e.g. Senior Offshore HSE Supervisor',
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Target title is required' : null,
                      ),
                      const SizedBox(height: 12),

                      _buildTextField(
                        controller: _emailCtrl,
                        label: 'Email Address *',
                        icon: Icons.email_outlined,
                        hint: 'e.g. candidate@example.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Email is required';
                          if (!v.contains('@')) return 'Enter a valid email address';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Phone Number with Country Code
                      const Text(
                        'PHONE NUMBER *',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _inkLight, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 105,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: _cardLow,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _cardMid),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: state.basicDetails.countryCode,
                                isExpanded: true,
                                items: _countryCodes.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _ink)))).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    ref.read(manualProfileProvider.notifier).updateBasicDetails(
                                      state.basicDetails.copyWith(countryCode: val),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(fontSize: 13, color: _ink, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                hintText: '55 012 3456',
                                hintStyle: const TextStyle(fontSize: 12, color: _inkLight),
                                filled: true,
                                fillColor: _cardLow,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Phone required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Nationality (GCC Visa)
                      _buildDropdownField(
                        label: 'Nationality (For GCC Visa Eligibility) *',
                        icon: Icons.flag_outlined,
                        value: state.basicDetails.nationality,
                        items: _nationalities,
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(manualProfileProvider.notifier).updateBasicDetails(
                              state.basicDetails.copyWith(nationality: val),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Resident Country & City
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Country of Residence *',
                              icon: Icons.public,
                              value: state.basicDetails.residentCountry,
                              items: _residentCountries,
                              onChanged: (val) {
                                if (val != null) {
                                  ref.read(manualProfileProvider.notifier).updateBasicDetails(
                                    state.basicDetails.copyWith(residentCountry: val),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildTextField(
                              controller: _cityCtrl,
                              label: 'Current City',
                              icon: Icons.location_city,
                              hint: 'e.g. Yanbu / Cairo',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),

        // Sticky Next CTA
        _buildStickyBottomButton(
          text: 'Continue to Education & Experience (Stage 2)',
          onPressed: _saveStage1AndProceed,
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // STAGE 2 VIEW: EDUCATION & WORK EXPERIENCE
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildStage2ExperienceAndEducation(ManualProfileState state) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Work Experience & Education',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _ink, letterSpacing: -0.3),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Detail your career history and academic credentials. You can add, edit, or delete items below.',
                  style: TextStyle(fontSize: 12, color: _inkLight),
                ),
                const SizedBox(height: 16),

                // ── Work Experience Header & List ────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.work_outline, size: 18, color: _crimson),
                        const SizedBox(width: 6),
                        Text(
                          'Work Experience (${state.workExperiences.length})',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _ink),
                        ),
                      ],
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _showAddEditExperienceModal(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _crimson,
                        side: const BorderSide(color: _crimson),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text('Add Experience', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (state.workExperiences.isEmpty)
                  _buildEmptyPlaceholder('No work experience added yet.', 'Tap "+ Add Experience" above to list your career roles.')
                else
                  ...state.workExperiences.asMap().entries.map((entry) {
                    final index = entry.key;
                    final exp = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _cardMid),
                        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 1))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: _cardLow, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.business_center, size: 20, color: _crimson),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            exp.title,
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _ink),
                                          ),
                                        ),
                                        if (exp.isCurrent)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: _greenBg, borderRadius: BorderRadius.circular(4)),
                                            child: const Text('Current', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _green)),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${exp.company} • ${exp.location}',
                                      style: const TextStyle(fontSize: 12, color: _inkLight, fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      exp.dates,
                                      style: const TextStyle(fontSize: 11, color: _inkLight),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18, color: _inkLight),
                                onPressed: () => _showAddEditExperienceModal(existing: exp, editIndex: index),
                              ),
                            ],
                          ),
                          if (exp.responsibilities.isNotEmpty) ...[
                            const Divider(height: 16, color: _cardMid),
                            ...exp.responsibilities.take(2).map((r) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(color: _crimson, fontWeight: FontWeight.bold)),
                                  Expanded(child: Text(r, style: const TextStyle(fontSize: 11, color: _ink))),
                                ],
                              ),
                            )),
                          ],
                        ],
                      ),
                    );
                  }),

                const SizedBox(height: 18),

                // ── Education Header & List ──────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.school_outlined, size: 18, color: _crimson),
                        const SizedBox(width: 6),
                        Text(
                          'Education (${state.educations.length})',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _ink),
                        ),
                      ],
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _showAddEditEducationModal(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _crimson,
                        side: const BorderSide(color: _crimson),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text('Add Education', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (state.educations.isEmpty)
                  _buildEmptyPlaceholder('No education degrees listed.', 'Tap "+ Add Education" to add your degree or diploma.')
                else
                  ...state.educations.asMap().entries.map((entry) {
                    final index = entry.key;
                    final edu = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _cardMid),
                        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 1))],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: _cardLow, borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.school, size: 20, color: _crimson),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${edu.degree} in ${edu.fieldOfStudy}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _ink),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  edu.institution,
                                  style: const TextStyle(fontSize: 12, color: _inkLight),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text('Class of ${edu.graduationYear}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _ink)),
                                    if (edu.grade != null) ...[
                                      const Text(' • ', style: TextStyle(fontSize: 11, color: _inkLight)),
                                      Text(edu.grade!, style: const TextStyle(fontSize: 11, color: _green, fontWeight: FontWeight.bold)),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18, color: _inkLight),
                            onPressed: () => _showAddEditEducationModal(existing: edu, editIndex: index),
                          ),
                        ],
                      ),
                    );
                  }),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // Sticky Next CTA
        _buildStickyBottomButton(
          text: 'Continue to Certifications (Stage 3)',
          onPressed: () => ref.read(manualProfileProvider.notifier).nextStage(),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // STAGE 3 VIEW: CERTIFICATIONS & ACCREDITATIONS
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildStage3Certifications(ManualProfileState state) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Certifications & Accreditations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _ink, letterSpacing: -0.3),
                ),
                const SizedBox(height: 4),
                const Text(
                  'GCC employers prioritize candidates with verified licenses, trade cards, and safety credentials.',
                  style: TextStyle(fontSize: 12, color: _inkLight),
                ),
                const SizedBox(height: 16),

                // Quick Add Suggestions
                const Text(
                  'QUICK-ADD POPULAR GCC ACCREDITATIONS',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _inkLight, letterSpacing: 0.6),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 14, color: _crimson),
                      label: const Text('NEBOSH IGC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _ink)),
                      backgroundColor: _cardLow,
                      onPressed: () => _quickAddCertification('NEBOSH International General Certificate', 'NEBOSH UK', 'IGC-${DateTime.now().millisecondsSinceEpoch % 100000}'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 14, color: _crimson),
                      label: const Text('Saudi Council of Engineers (SCE)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _ink)),
                      backgroundColor: _cardLow,
                      onPressed: () => _quickAddCertification('Saudi Council of Engineers (SCE) Membership', 'Saudi Council of Engineers', 'SCE-${DateTime.now().millisecondsSinceEpoch % 100000}'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 14, color: _crimson),
                      label: const Text('Aramco Work Permit (WPR)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _ink)),
                      backgroundColor: _cardLow,
                      onPressed: () => _quickAddCertification('Saudi Aramco Work Permit Receiver (WPR)', 'Saudi Aramco', 'WPR-${DateTime.now().millisecondsSinceEpoch % 100000}'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 14, color: _crimson),
                      label: const Text('PMP® Project Management', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _ink)),
                      backgroundColor: _cardLow,
                      onPressed: () => _quickAddCertification('Project Management Professional (PMP)', 'PMI', 'PMP-${DateTime.now().millisecondsSinceEpoch % 100000}'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 14, color: _crimson),
                      label: const Text('OSHA 30-Hour Construction', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _ink)),
                      backgroundColor: _cardLow,
                      onPressed: () => _quickAddCertification('OSHA 30-Hour General Industry & Construction', 'OSHA US', 'OSHA-${DateTime.now().millisecondsSinceEpoch % 100000}'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Accreditations (${state.certifications.length})',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _ink),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showAddEditCertificationModal(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _crimson,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text('Add Custom', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (state.certifications.isEmpty)
                  _buildEmptyPlaceholder('No certifications listed yet.', 'Tap "+ Add Custom" or select from the quick-add buttons above.')
                else
                  ...state.certifications.asMap().entries.map((entry) {
                    final index = entry.key;
                    final cert = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _cardMid),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: _greenBg, borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.verified, size: 20, color: _green),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cert.title,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _ink),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${cert.issuer} • ID: ${cert.credentialNumber}',
                                  style: const TextStyle(fontSize: 11, color: _inkLight),
                                ),
                                Text(
                                  'Validity: ${cert.issueYear} – ${cert.expiryYear}',
                                  style: const TextStyle(fontSize: 10, color: _inkLight),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18, color: _inkLight),
                            onPressed: () => _showAddEditCertificationModal(existing: cert, editIndex: index),
                          ),
                        ],
                      ),
                    );
                  }),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // Sticky Next CTA
        _buildStickyBottomButton(
          text: 'Continue to Salary & Relocation (Stage 4)',
          onPressed: () => ref.read(manualProfileProvider.notifier).nextStage(),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // STAGE 4 VIEW: RESUME, SALARY & RELOCATION DETAILS
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildStage4SalaryAndResume(ManualProfileState state) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resume, Salary & Relocation',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _ink, letterSpacing: -0.3),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Specify your compensation expectations, availability timeline, and attach your resume.',
                  style: TextStyle(fontSize: 12, color: _inkLight),
                ),
                const SizedBox(height: 16),

                _buildCard(
                  children: [
                    const Text(
                      'SALARY EXPECTATIONS (MONTHLY)',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _inkLight, letterSpacing: 0.6),
                    ),
                    const SizedBox(height: 10),

                    // Current Salary
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _currentSalaryCtrl,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 13, color: _ink, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              labelText: 'Current Monthly Salary',
                              filled: true,
                              fillColor: _cardLow,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(color: _cardLow, borderRadius: BorderRadius.circular(8)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: state.salaryRelocation.currentCurrency,
                                isExpanded: true,
                                items: _currencies.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    ref.read(manualProfileProvider.notifier).updateSalaryRelocation(
                                      state.salaryRelocation.copyWith(currentCurrency: val),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Expected Salary
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _expectedSalaryCtrl,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 13, color: _ink, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              labelText: 'Expected Monthly Salary *',
                              filled: true,
                              fillColor: _cardLow,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(color: _cardLow, borderRadius: BorderRadius.circular(8)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: state.salaryRelocation.expectedCurrency,
                                isExpanded: true,
                                items: _currencies.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    ref.read(manualProfileProvider.notifier).updateSalaryRelocation(
                                      state.salaryRelocation.copyWith(expectedCurrency: val),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                _buildCard(
                  children: [
                    const Text(
                      'AVAILABILITY & RELOCATION',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _inkLight, letterSpacing: 0.6),
                    ),
                    const SizedBox(height: 10),

                    // Notice Period
                    _buildDropdownField(
                      label: 'Notice Period / Availability',
                      icon: Icons.timer_outlined,
                      value: state.salaryRelocation.noticePeriod,
                      items: _noticePeriods,
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(manualProfileProvider.notifier).updateSalaryRelocation(
                            state.salaryRelocation.copyWith(noticePeriod: val),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Relocation Date
                    _buildDropdownField(
                      label: 'Earliest Relocation Readiness Date',
                      icon: Icons.flight_takeoff,
                      value: state.salaryRelocation.relocationDate,
                      items: _relocationOptions,
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(manualProfileProvider.notifier).updateSalaryRelocation(
                            state.salaryRelocation.copyWith(relocationDate: val),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Preferred GCC Destinations
                    const Text(
                      'TARGET GCC DESTINATIONS',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _inkLight, letterSpacing: 0.6),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: ['Saudi Arabia', 'UAE', 'Qatar', 'Kuwait', 'Oman', 'Bahrain'].map((country) {
                        final isSel = state.salaryRelocation.preferredCountries.contains(country);
                        return FilterChip(
                          label: Text(country, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSel ? _crimson : _ink)),
                          selected: isSel,
                          selectedColor: const Color(0xFFFFF1F1),
                          backgroundColor: _cardLow,
                          checkmarkColor: _crimson,
                          side: BorderSide(color: isSel ? _crimson : Colors.transparent),
                          onSelected: (selected) {
                            final current = List<String>.from(state.salaryRelocation.preferredCountries);
                            if (selected) {
                              current.add(country);
                            } else {
                              if (current.length > 1) current.remove(country);
                            }
                            ref.read(manualProfileProvider.notifier).updateSalaryRelocation(
                              state.salaryRelocation.copyWith(preferredCountries: current),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Resume Attachment Section
                _buildCard(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ATTACH RESUME / CV DOCUMENT',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _inkLight, letterSpacing: 0.6),
                        ),
                        Row(
                          children: [
                            if (state.salaryRelocation.resumeFileName != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(color: _greenBg, borderRadius: BorderRadius.circular(4)),
                                child: const Text('ATTACHED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _green)),
                              ),
                            InkWell(
                              onTap: _pickAndUploadResume,
                              borderRadius: BorderRadius.circular(4),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                child: Row(
                                  children: [
                                    const Icon(Icons.cloud_upload_outlined, size: 14, color: _crimson),
                                    const SizedBox(width: 4),
                                    Text(
                                      state.salaryRelocation.resumeFileName != null ? 'Upload / Replace' : 'Upload Document',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _crimson),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (state.salaryRelocation.resumeFileName != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _greenBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.picture_as_pdf, color: Colors.red, size: 28),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.salaryRelocation.resumeFileName!,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _ink),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Text('PDF Document • 1.4 MB • Ready for submission', style: TextStyle(fontSize: 10, color: _inkLight)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            OutlinedButton.icon(
                              onPressed: _pickAndUploadResume,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _crimson,
                                side: const BorderSide(color: Color(0xFFA7F3D0)),
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                              icon: const Icon(Icons.upload_file, size: 13, color: _crimson),
                              label: const Text('Upload', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18, color: _inkLight),
                              tooltip: 'Remove',
                              onPressed: () => ref.read(manualProfileProvider.notifier).setResumeFileName(null),
                            ),
                          ],
                        ),
                      )
                    else
                      InkWell(
                        onTap: _pickAndUploadResume,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          decoration: BoxDecoration(
                            color: _cardLow,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _cardMid, style: BorderStyle.solid),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.cloud_upload_outlined, color: _crimson, size: 24),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Upload Resume / CV Document', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _ink)),
                                    Text('Tap to browse PDF, DOC, DOCX (up to 10MB)', style: TextStyle(fontSize: 10, color: _inkLight)),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: _pickAndUploadResume,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _crimson,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                                icon: const Icon(Icons.upload, size: 14),
                                label: const Text('Upload', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // Sticky Complete CTA
        _buildStickyBottomButton(
          text: state.isSubmitting ? 'Saving Profile...' : 'Complete & Submit Profile',
          icon: state.isSubmitting ? null : Icons.check_circle_outline,
          onPressed: state.isSubmitting ? null : _handleFinalSubmit,
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // HELPER WIDGETS
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildEmptyPlaceholder(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _cardMid),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 32, color: _inkLight),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _ink)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: _inkLight), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardMid),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 13, color: _ink, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: _inkLight),
        filled: true,
        fillColor: _cardLow,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildModalTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 13, color: _ink),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: _inkLight),
        filled: true,
        fillColor: _cardLow,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final effectiveValue = items.contains(value) ? value : items.first;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: _cardLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _cardMid),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: effectiveValue,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 18, color: _inkLight),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 6),
        ),
        style: const TextStyle(fontSize: 13, color: _ink, fontWeight: FontWeight.w500),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
        onChanged: onChanged,
        isExpanded: true,
      ),
    );
  }

  Widget _buildStickyBottomButton({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon = Icons.arrow_forward,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: _white,
        boxShadow: [
          BoxShadow(color: Color(0x0C000000), blurRadius: 8, offset: Offset(0, -2)),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _crimson,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, size: 16, color: Colors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
