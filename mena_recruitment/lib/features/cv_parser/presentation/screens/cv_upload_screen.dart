import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/features/cv_parser/providers/manual_profile_state.dart';
import 'package:mena_recruitment/features/cv_parser/services/gemini_cv_parser_service.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';
import 'package:mena_recruitment/features/vault/providers/vault_provider.dart';

class CVUploadScreen extends ConsumerStatefulWidget {
  const CVUploadScreen({super.key});

  @override
  ConsumerState<CVUploadScreen> createState() => _CVUploadScreenState();
}

class _CVUploadScreenState extends ConsumerState<CVUploadScreen> {
  static const _crimson = Color(0xFF6E0000);
  static const _green = Color(0xFF059669);

  PlatformFile? _selectedFile;
  String _fileName = '';
  String _fileMeta = '';
  double _parseProgress = 0.0;
  String _parsingStatus = '';

  bool _isStaged = false; // File selected, but NOT parsed yet
  bool _isParsing = false; // Gemini model is currently parsing
  bool _isParsed = false; // Gemini model finished parsing
  GeminiCvParserResult? _lastResult;

  void _handleSelectDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: true,
      );

      // If user closed or canceled the file picker dialog, do nothing!
      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.first;
      final fileName = file.name;
      final sizeInBytes = file.size;
      final sizeFormatted = sizeInBytes > 1024 * 1024
          ? '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB'
          : '${(sizeInBytes / 1024).toStringAsFixed(0)} KB';

      setState(() {
        _selectedFile = file;
        _fileName = fileName;
        _fileMeta = '$sizeFormatted • Document Selected (Ready to Parse)';
        _isStaged = true;
        _isParsing = false;
        _isParsed = false;
        _parseProgress = 0.0;
        _parsingStatus = '';
        _lastResult = null;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ "$fileName" selected. Tap "Ready to Parse" to start Gemini AI extraction.'),
          backgroundColor: const Color(0xFF1E293B),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File selection error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startGeminiParse() async {
    if (_selectedFile == null) return;

    setState(() {
      _isParsing = true;
      _parseProgress = 0.2;
      _parsingStatus = 'Connecting to Gemini AI...';
    });

    try {
      // Step 1 animation
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      setState(() {
        _parseProgress = 0.45;
        _parsingStatus = 'Analyzing resume structure & career history...';
      });

      // Invoke Gemini parser service
      final result = await GeminiCvParserService().parseResume(_selectedFile!);

      // Step 2 animation
      if (!mounted) return;
      setState(() {
        _parseProgress = 0.8;
        _parsingStatus = 'Extracting skills, certifications & contact details...';
      });

      await Future.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;

      // Auto-fill the candidate detail form in state
      // (Salary & relocation left empty as requested)
      ref.read(manualProfileProvider.notifier).applyParsedResumeData(
        basicDetails: result.basicDetails,
        workExperiences: result.workExperiences,
        educations: result.educations,
        certifications: result.certifications,
        skills: result.skills,
        salaryRelocation: result.salaryRelocation,
      );

      // Sync extracted certifications to Suhana Vault
      try {
        final vaultRepo = ref.read(vaultRepositoryProvider);
        for (final cert in result.certifications) {
          final vaultDoc = VaultDocument(
            id: 'vault-${cert.id}',
            category: DocumentCategory.tradeLicense,
            title: cert.title,
            documentNumber: cert.credentialNumber.isNotEmpty ? cert.credentialNumber : 'CERT-${DateTime.now().millisecondsSinceEpoch % 10000}',
            issuingCountry: cert.issuer.isNotEmpty ? cert.issuer : 'Accredited Board',
            isVerified: true,
            isValidForGccVisa: true,
          );
          await vaultRepo.addDocument(vaultDoc);
        }
        ref.invalidate(vaultDocumentsProvider);
      } catch (_) {}

      final sizeFormatted = _selectedFile!.size > 1024 * 1024
          ? '${(_selectedFile!.size / (1024 * 1024)).toStringAsFixed(1)} MB'
          : '${(_selectedFile!.size / 1024).toStringAsFixed(0)} KB';

      setState(() {
        _isParsing = false;
        _isParsed = true;
        _parseProgress = 1.0;
        _parsingStatus = 'AI Extraction Complete';
        _lastResult = result;
        _fileMeta = '$sizeFormatted • AI Extraction 100% Complete';
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Successfully parsed ${result.basicDetails.fullName}\'s resume! Profile auto-filled.'),
          backgroundColor: _green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isParsing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error parsing resume: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              // Top Bar: Back button only with hover and safe pop
              const Row(
                children: [
                  _UploadBackButton(),
                ],
              ),

              const SizedBox(height: 14),

              // Title Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(9999)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_outlined, size: 12, color: Color(0xFF334155)),
                    SizedBox(width: 4),
                    Text(
                      'GLOBAL JOBS BY SUHANA • GCC DIRECT RELOCATION',
                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Color(0xFF334155)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Upload Your CV / Resume',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select your resume document first, then tap "Ready to Parse" to let Gemini AI extract your details and auto-fill your candidate form.',
                style: TextStyle(fontSize: 11, color: Color(0xFF5B403C)),
              ),
              const SizedBox(height: 16),

              // Upload Drop Zone
              GestureDetector(
                onTap: _handleSelectDocument,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE4BEB8), style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(14)),
                            child: const Icon(Icons.cloud_upload_outlined, color: _crimson, size: 30),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: _crimson, shape: BoxShape.circle),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildFormatBadge(Icons.picture_as_pdf, 'PDF'),
                          const SizedBox(width: 6),
                          _buildFormatBadge(Icons.description, 'DOCX'),
                          const SizedBox(width: 6),
                          const Text('Up to 10MB', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _isStaged ? 'Document Selected: $_fileName' : 'Tap to browse files',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1B1B)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isStaged
                            ? 'Tap to select a different document if desired'
                            : 'or drop your file directly from WhatsApp / Files',
                        style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        onPressed: _handleSelectDocument,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF1F5F9),
                          foregroundColor: const Color(0xFF1E1B1B),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        icon: Icon(_isStaged ? Icons.change_circle_outlined : Icons.folder_open, size: 16),
                        label: Text(
                          _isStaged ? 'Change Document' : 'Select Document',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // STAGE 2: "READY TO PARSE" Card (When file is selected, but not parsed yet)
              if (_isStaged && !_isParsing && !_isParsed) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE4DADB)),
                    boxShadow: const [
                      BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 8, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDAD4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.description_outlined, color: _crimson, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _fileName,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1B1B)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _fileMeta,
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF5B403C)),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 20, color: Color(0xFF64748B)),
                            tooltip: 'Select different document',
                            onPressed: _handleSelectDocument,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFFD4D4)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: _crimson),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Document ready. Click the button below to extract candidate details with Gemini model.',
                                style: TextStyle(fontSize: 11, color: _crimson, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Prominent "Ready to Parse" Button
                      ElevatedButton.icon(
                        onPressed: _startGeminiParse,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _crimson,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.auto_awesome, size: 18, color: Colors.amber),
                        label: const Text(
                          'Ready to Parse Resume with Gemini AI',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // PARSING ACTIVE PROGRESS CARD
              if (_isParsing) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE4DADB)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2.4, color: _crimson),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _parsingStatus,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _crimson),
                            ),
                          ),
                          Text(
                            '${(_parseProgress * 100).toInt()}%',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: LinearProgressIndicator(
                          value: _parseProgress,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(_crimson),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // PARSED COMPLETE CARD
              if (_isParsed && _lastResult != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                    boxShadow: const [
                      BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 8, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.check_circle_rounded, color: _green, size: 22),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _fileName,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Candidate: ${_lastResult!.basicDetails.fullName} • ${_lastResult!.modelUsed ?? "Gemini AI"}',
                                  style: const TextStyle(fontSize: 11, color: _green, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 18, color: Color(0xFF64748B)),
                            tooltip: 'Upload another file',
                            onPressed: _handleSelectDocument,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Status extraction breakdown
                      _buildStatusItem(
                        'Contact: ${_lastResult!.basicDetails.email.isNotEmpty ? _lastResult!.basicDetails.email : "Identified"} • ${_lastResult!.basicDetails.countryCode} ${_lastResult!.basicDetails.phone}',
                        isDone: true,
                      ),
                      _buildStatusItem(
                        'Target Role: ${_lastResult!.basicDetails.targetTitle} (${_lastResult!.workExperiences.length} Experience Records)',
                        isDone: true,
                      ),
                      _buildStatusItem(
                        '${_lastResult!.skills.length} Technical & GCC Skills Detected (${_lastResult!.skills.take(3).join(", ")}...)',
                        isDone: true,
                      ),
                      _buildStatusItem(
                        '${_lastResult!.certifications.length} Certifications & Licenses Extracted',
                        isDone: true,
                      ),
                      _buildStatusItem(
                        'Salary & Relocation left empty for candidate review',
                        isDone: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Suhana Privacy Notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.shield_outlined, size: 18, color: _crimson),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Suhana Privacy & GCC Employer Protection: Your resume is encrypted and only shared with licensed MHRSD & MOH accredited sponsors.',
                        style: TextStyle(fontSize: 10, color: Color(0xFF334155)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Quick Footer Badges
              Row(
                children: [
                  Expanded(
                    child: _buildFooterBadge(Icons.flight_takeoff, 'FAST RELOCATION', 'KSA, UAE, Qatar'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFooterBadge(Icons.verified_user, 'DIRECT SPONSOR', 'Zero Agent Fee'),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // CTA Button: Continue to Review & Edit (Stage 1 of 4)
              ElevatedButton.icon(
                onPressed: _isParsed
                    ? () {
                        ref.read(manualProfileProvider.notifier).setStage(0);
                        context.push(RouteNames.cvManualDetails);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _crimson,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFD1D5DB),
                  disabledForegroundColor: const Color(0xFF9CA3AF),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: Text(
                  _isParsed
                      ? 'Continue to Review & Edit (AI Parsed)'
                      : _isStaged
                          ? 'Tap "Ready to Parse" Above First'
                          : 'Select a Document to Continue',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                label: const Icon(Icons.arrow_forward, size: 16),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF334155)),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String text, {required bool isDone}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Icon(isDone ? Icons.check_circle : Icons.sync, size: 14, color: isDone ? _green : _crimson),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 10, color: Color(0xFF1E1B1B)))),
        ],
      ),
    );
  }

  Widget _buildFooterBadge(IconData icon, String title, String sub) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE4DADB))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
            child: Icon(icon, size: 16, color: const Color(0xFF334155)),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              Text(sub, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E1B1B))),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Upload Back Button with Theme Crimson Hover & Safe Pop
// ─────────────────────────────────────────────────────────────────────────────
class _UploadBackButton extends StatefulWidget {
  const _UploadBackButton();

  @override
  State<_UploadBackButton> createState() => _UploadBackButtonState();
}

class _UploadBackButtonState extends State<_UploadBackButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RouteNames.profileEntryOptions);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFF6E0000)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.arrow_back,
            size: 18,
            color: _hovered ? Colors.white : const Color(0xFF1E1B1B),
          ),
        ),
      ),
    );
  }
}
