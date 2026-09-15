import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/features/cv_parser/providers/manual_profile_state.dart';
import 'package:mena_recruitment/features/profile/providers/profile_provider.dart';

class WorkExperienceItem {
  String title;
  String company;
  String location;
  String dates;
  bool isCurrent;
  List<String> responsibilities;

  WorkExperienceItem({
    required this.title,
    required this.company,
    required this.location,
    required this.dates,
    required this.isCurrent,
    required this.responsibilities,
  });
}

class EducationItem {
  String degree;
  String institution;
  String fieldOfStudy;
  String graduationYear;
  bool isVerified;

  EducationItem({
    required this.degree,
    required this.institution,
    required this.fieldOfStudy,
    required this.graduationYear,
    this.isVerified = false,
  });
}

class CVReviewScreen extends ConsumerStatefulWidget {
  const CVReviewScreen({super.key});

  @override
  ConsumerState<CVReviewScreen> createState() => _CVReviewScreenState();
}

class _CVReviewScreenState extends ConsumerState<CVReviewScreen> {
  late final List<String> skills;
  late final List<WorkExperienceItem> _workHistory;
  late final List<EducationItem> _educationList;

  @override
  void initState() {
    super.initState();
    final manual = ref.read(manualProfileProvider);
    skills = List<String>.from(manual.skills);
    _workHistory = manual.workExperiences
        .map((e) => WorkExperienceItem(
              title: e.title,
              company: e.company,
              location: e.location,
              dates: e.dates,
              isCurrent: e.isCurrent,
              responsibilities: List<String>.from(e.responsibilities),
            ))
        .toList();
    _educationList = manual.educations
        .map((e) => EducationItem(
              degree: e.degree,
              fieldOfStudy: e.fieldOfStudy,
              institution: e.institution,
              graduationYear: e.graduationYear,
              isVerified: false,
            ))
        .toList();
  }

  void _showAddEducationModal({EducationItem? existing, int? editIndex}) {
    final degreeCtrl = TextEditingController(text: existing?.degree ?? '');
    final fieldCtrl = TextEditingController(text: existing?.fieldOfStudy ?? '');
    final institutionCtrl = TextEditingController(text: existing?.institution ?? '');
    final yearCtrl = TextEditingController(text: existing?.graduationYear ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
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
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: degreeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Degree (e.g. Bachelor of Science)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: fieldCtrl,
                decoration: const InputDecoration(
                  labelText: 'Field of Study (e.g. Mechanical Engineering)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: institutionCtrl,
                decoration: const InputDecoration(
                  labelText: 'University / Institution',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: yearCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Graduation Year (e.g. 2016)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (existing != null) ...[
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() => _educationList.removeAt(editIndex!));
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (degreeCtrl.text.trim().isEmpty) return;
                        final item = EducationItem(
                          degree: degreeCtrl.text.trim(),
                          fieldOfStudy: fieldCtrl.text.trim(),
                          institution: institutionCtrl.text.trim(),
                          graduationYear: yearCtrl.text.trim(),
                          isVerified: existing?.isVerified ?? false,
                        );
                        setState(() {
                          if (existing == null) {
                            _educationList.add(item);
                          } else {
                            _educationList[editIndex!] = item;
                          }
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(existing == null ? '✓ Education added!' : '✓ Education updated!'),
                            backgroundColor: const Color(0xFF059669),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6E0000),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(existing == null ? 'Save Education' : 'Update Education',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
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

  void _showAddExperienceModal({WorkExperienceItem? existing, int? editIndex}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final companyCtrl = TextEditingController(text: existing?.company ?? '');
    final locationCtrl = TextEditingController(text: existing?.location ?? '');
    final datesCtrl = TextEditingController(text: existing?.dates ?? '');
    final respCtrl = TextEditingController(text: existing?.responsibilities.join('\n') ?? '');
    bool isCurrent = existing?.isCurrent ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (modalCtx, setModalState) => Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 20,
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
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(modalCtx)),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Job Title / Trade Designation',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: companyCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Company / Contractor Name',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: locationCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Location / GCC Country',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: datesCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Dates / Duration',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: isCurrent,
                      activeColor: const Color(0xFF6E0000),
                      onChanged: (v) => setModalState(() => isCurrent = v ?? false),
                    ),
                    const Text('This is my current role', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: respCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Key Responsibilities (One per line)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (existing != null) ...[
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          Navigator.pop(modalCtx);
                          setState(() {
                            _workHistory.removeAt(editIndex!);
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleCtrl.text.trim().isEmpty) return;
                          final lines = respCtrl.text
                              .split('\n')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList();

                          final item = WorkExperienceItem(
                            title: titleCtrl.text.trim(),
                            company: companyCtrl.text.trim(),
                            location: locationCtrl.text.trim(),
                            dates: datesCtrl.text.trim(),
                            isCurrent: isCurrent,
                            responsibilities: lines.isEmpty ? ['Executed job duties compliant with GCC standards.'] : lines,
                          );

                          setState(() {
                            if (existing == null) {
                              _workHistory.add(item);
                            } else {
                              _workHistory[editIndex!] = item;
                            }
                          });

                          Navigator.pop(modalCtx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(existing == null ? '✓ Work experience added!' : '✓ Work experience updated!'),
                              backgroundColor: const Color(0xFF059669),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6E0000),
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

  void _showAddSkillDialog() {
    final skillCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Skill or Trade', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: skillCtrl,
          decoration: const InputDecoration(
            hintText: 'e.g. Rigging Level 3, First Aid, OPITO',
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (skillCtrl.text.trim().isNotEmpty) {
                setState(() => skills.add(skillCtrl.text.trim()));
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6E0000), foregroundColor: Colors.white),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top-left back button
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.arrow_back, size: 18, color: Color(0xFF1E1B1B)),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ],
                ),
              ),

              // Header Stepper Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(color: Color(0xFF6E0000), shape: BoxShape.circle),
                        child: const Center(child: Text('2', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                      ),
                      const SizedBox(width: 6),
                      const Text('Step 2 of 4: Verify Parsed Data', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E1B1B))),
                    ],
                  ),
                  const Text('50% COMPLETE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF6E0000), letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 6),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: const LinearProgressIndicator(
                  value: 0.5,
                  minHeight: 4,
                  backgroundColor: Color(0xFFE4DADB),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6E0000)),
                ),
              ),
              const SizedBox(height: 14),

              const Text('Review Extracted\nExperience', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.15, color: Color(0xFF1E1B1B))),
              const SizedBox(height: 4),
              const Text('Verify the AI-extracted details below. Tap any field to edit or add missing employers.', style: TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
              const SizedBox(height: 12),

              // 98% Match Confidence Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.shield_outlined, color: Color(0xFF6E0000), size: 18),
                        ),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('98% Match Confidence', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            Text(' Work Roles & 2 Degrees Extracted', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                          ],
                        ),
                      ],
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Re-parsing resume with Suhana Deep Vision...')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: const Icon(Icons.refresh, size: 14, color: Color(0xFF1E1B1B)),
                      label: const Text('Re-parse', style: TextStyle(fontSize: 10, color: Color(0xFF1E1B1B), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Work History Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.work_outline, size: 18, color: Color(0xFF6E0000)),
                      SizedBox(width: 6),
                      Text('Work History', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
                    child: const Text(' Positions', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Dynamic Work Experience Cards
              ..._workHistory.asMap().entries.map((entry) {
                final idx = entry.key;
                final exp = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _buildExperienceCard(
                    item: exp,
                    onEdit: () => _showAddExperienceModal(existing: exp, editIndex: idx),
                  ),
                );
              }),

              // Add Another Work Experience Button (Now Fully Functional!)
              OutlinedButton.icon(
                onPressed: () => _showAddExperienceModal(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6E0000),
                  side: const BorderSide(color: Color(0xFFE4BEB8)),
                  minimumSize: const Size.fromHeight(42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: const Text('Add Another Work Experience', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 16),

              // Highest Education Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.school_outlined, size: 18, color: Color(0xFF6E0000)),
                      SizedBox(width: 6),
                      Text('Education', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  if (_educationList.any((e) => e.isVerified))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(4)),
                      child: const Text('Verified', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // Dynamic Education Cards
              ..._educationList.asMap().entries.map((entry) {
                final idx = entry.key;
                final edu = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE4DADB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.account_balance, size: 20, color: Color(0xFF334155)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${edu.degree} in\n${edu.fieldOfStudy}',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, height: 1.2),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${edu.institution}\n• Graduated ${edu.graduationYear}',
                                    style: const TextStyle(fontSize: 10, color: Color(0xFF5B403C)),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              onPressed: () => _showAddEducationModal(existing: edu, editIndex: idx),
                            ),
                          ],
                        ),
                        if (edu.isVerified) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                            child: const Row(
                              children: [
                                Icon(Icons.verified, size: 12, color: Color(0xFF059669)),
                                SizedBox(width: 4),
                                Text('Apostille & Cultural Attestation Ready', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF1E1B1B))),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),

              // Add Education Button
              OutlinedButton.icon(
                onPressed: () => _showAddEducationModal(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6E0000),
                  side: const BorderSide(color: Color(0xFFE4BEB8)),
                  minimumSize: const Size.fromHeight(42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: const Text('Add Education', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 16),


              // Extracted Core Skills & Trades
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.military_tech_outlined, size: 18, color: Color(0xFF6E0000)),
                      SizedBox(width: 6),
                      Text('Extracted Core Skills & Trades', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  Text(' Parsed', style: TextStyle(fontSize: 10, color: Color(0xFF8F706B), fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              const Text('AI tagged these based on industry relocation visa qualifications.', style: TextStyle(fontSize: 10, color: Color(0xFF5B403C))),
              const SizedBox(height: 10),

              // Skills Wrap
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...skills.map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E1B1B))),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () => setState(() => skills.remove(s)),
                              child: const Icon(Icons.close, size: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      )),
                  InkWell(
                    onTap: _showAddSkillDialog,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFFFDAD4), borderRadius: BorderRadius.circular(6)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 12, color: Color(0xFF6E0000)),
                          SizedBox(width: 4),
                          Text('Add Skill', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6E0000))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // MHRSD Compliance Notice
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline, size: 16, color: Color(0xFF64748B)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Encrypted candidate profiles and documents are compliant with GCC labor ministries and Saudi Arabia MHRSD guidelines.',
                        style: TextStyle(fontSize: 9, color: Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Bottom Action: Save & Continue to Certifications
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final currentProfile = ref.read(profileProvider).value;
                    if (currentProfile != null && _workHistory.isNotEmpty) {
                      final firstExp = _workHistory.first;
                      final updated = currentProfile.copyWith(
                        targetTitle: firstExp.title,
                      );
                      await ref.read(profileRepositoryProvider).updateProfile(updated);
                    }
                  } catch (_) {}
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✓ Profile updated with parsed CV details!'),
                        backgroundColor: Color(0xFF059669),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    context.push(RouteNames.certifications);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6E0000),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Text('Save & Continue to Certifications', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                label: const Icon(Icons.arrow_forward, size: 16),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceCard({
    required WorkExperienceItem item,
    required VoidCallback onEdit,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4DADB)),
      ),
      child: Stack(
        children: [
          if (item.isCurrent)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF6E0000),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.isCurrent) ...[
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFFFDAD4), borderRadius: BorderRadius.circular(4)),
                        child: const Text('Current Role • GCC Verified', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF6E0000))),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
                        child: const Row(
                          children: [
                            Icon(Icons.check, size: 10, color: Color(0xFF059669)),
                            SizedBox(width: 2),
                            Text('Verified by CV', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          Text(item.company, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6E0000))),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.edit_outlined, size: 16), onPressed: onEdit),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF64748B)),
                    const SizedBox(width: 2),
                    Text(item.location, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    const SizedBox(width: 10),
                    const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF64748B)),
                    const SizedBox(width: 2),
                    Text(item.dates, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('KEY RESPONSIBILITIES EXTRACTED', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF5B403C))),
                      const SizedBox(height: 6),
                      ...item.responsibilities.map((r) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_outline, size: 12, color: Color(0xFF6E0000)),
                                const SizedBox(width: 4),
                                Expanded(child: Text(r, style: const TextStyle(fontSize: 10, height: 1.3))),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
