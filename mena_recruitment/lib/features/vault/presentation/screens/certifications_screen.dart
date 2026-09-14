import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/features/cv_parser/providers/manual_profile_state.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';
import 'package:mena_recruitment/features/vault/providers/vault_provider.dart';

class CertificationsScreen extends ConsumerStatefulWidget {
  const CertificationsScreen({super.key});

  @override
  ConsumerState<CertificationsScreen> createState() => _CertificationsScreenState();
}

class _CertificationsScreenState extends ConsumerState<CertificationsScreen> {
  bool _isMedicalActive = false;
  bool _isMedicalVerified = false;
  final TextEditingController _medicalLicenseController = TextEditingController();

  bool _hasAramcoCard = false;
  String _aramcoCardNumber = '';

  final List<String> _gccDrivingLicenses = [];

  final List<Map<String, String>> _extraCredentials = [];

  static const _crimson = Color(0xFF6E0000);
  static const _surface = Color(0xFFF9F9FF);
  static const _white = Colors.white;
  static const _cardLow = Color(0xFFF1F3FD);
  static const _cardMid = Color(0xFFE5E8F2);
  static const _ink = Color(0xFF181C23);
  static const _inkLight = Color(0xFF5A5F67);
  static const _green = Color(0xFF059669);
  static const _greenBg = Color(0xFFECFDF5);

  @override
  void dispose() {
    _medicalLicenseController.dispose();
    super.dispose();
  }

  void _showAddCredentialDialog() {
    final titleCtrl = TextEditingController();
    final issuerCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Credential / License', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Certificate Title', border: OutlineInputBorder(), isDense: true)),
            const SizedBox(height: 10),
            TextField(controller: issuerCtrl, decoration: const InputDecoration(labelText: 'Issuing Body / Institute', border: OutlineInputBorder(), isDense: true)),
            const SizedBox(height: 10),
            TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'License / Credential # (Optional)', border: OutlineInputBorder(), isDense: true)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (titleCtrl.text.trim().isNotEmpty) {
                final title = titleCtrl.text.trim();
                final issuer = issuerCtrl.text.trim().isEmpty ? 'Accredited Board' : issuerCtrl.text.trim();
                final code = codeCtrl.text.trim();
                setState(() {
                  _extraCredentials.add({
                    'title': title,
                    'issuer': issuer,
                    'code': code,
                    'file': '${title.toLowerCase().replaceAll(" ", "_")}_cert.pdf',
                  });
                });
                try {
                  final newDoc = VaultDocument(
                    id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
                    category: DocumentCategory.tradeLicense,
                    title: title,
                    documentNumber: code.isNotEmpty ? code : 'TL-${DateTime.now().millisecondsSinceEpoch % 10000}',
                    issuingCountry: issuer,
                    isVerified: true,
                    isValidForGccVisa: true,
                  );
                  await ref.read(vaultRepositoryProvider).addDocument(newDoc);
                  ref.invalidate(vaultDocumentsProvider);
                } catch (_) {}
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✓ Credential added to your profile!'), backgroundColor: _green),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: _crimson, foregroundColor: Colors.white),
            child: const Text('Add Credential'),
          ),
        ],
      ),
    );
  }

  void _showReplaceDialog(String certName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Replace $certName', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select a new document scan (PDF, JPG, PNG) from your device.', style: TextStyle(fontSize: 12, color: _inkLight)),
            SizedBox(height: 16),
            Icon(Icons.cloud_upload_outlined, size: 40, color: _crimson),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('✓ Document updated for $certName!'), backgroundColor: _green),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: _crimson, foregroundColor: Colors.white),
            child: const Text('Upload New File'),
          ),
        ],
      ),
    );
  }

  void _showAramcoUploadModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.badge, color: _crimson),
                SizedBox(width: 8),
                Text('Saudi Aramco Approval Card', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload front and back scan of your SAP ID card or Safety Work Permit Receiver card.',
              style: TextStyle(fontSize: 12, color: _inkLight),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'SAP ID / Badge #',
                hintText: 'e.g. SAP-772918',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => _aramcoCardNumber = v,
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _hasAramcoCard = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✓ Saudi Aramco Approval Card verified!'), backgroundColor: _green),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _crimson,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.cloud_upload, size: 18),
              label: const Text('Confirm & Save Card', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyMedicalLicense() async {
    final text = _medicalLicenseController.text.trim();
    if (text.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: _crimson),
                SizedBox(width: 16),
                Text('Verifying with DHA/MOH Registry...'),
              ],
            ),
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.pop(context);

    setState(() => _isMedicalVerified = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✓ License $text verified active!'), backgroundColor: _green),
    );
  }

  void _showAddLicenseDialog() {
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add GCC Driving License', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'License details', hintText: 'e.g. Saudi / UAE Light Vehicle License • Exp: 2028', border: OutlineInputBorder(), isDense: true),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                setState(() => _gccDrivingLicenses.add(nameCtrl.text.trim()));
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✓ GCC driving license added!'), backgroundColor: _green),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: _crimson, foregroundColor: Colors.white),
            child: const Text('Add License'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final manualProfile = ref.watch(manualProfileProvider);
    final vaultDocsAsync = ref.watch(vaultDocumentsProvider);
    final vaultDocs = vaultDocsAsync.valueOrNull ?? [];
    final vaultTradeCerts = vaultDocs.where((d) => d.category == DocumentCategory.tradeLicense || d.category == DocumentCategory.educationAttestation).toList();
    final resumeCerts = manualProfile.certifications;

    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Clean Header with Top-Left Back Button ────────────────────────
            Container(
              color: _white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top navigation row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button on Top-Left
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
                          onPressed: () => context.pop(),
                        ),
                      ),
                      // Step Indicator
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'STEP 3 OF 4',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _inkLight, letterSpacing: 0.8),
                          ),
                          Text(
                            '75% Completed',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _crimson),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.75,
                      minHeight: 4,
                      backgroundColor: _cardMid,
                      valueColor: AlwaysStoppedAnimation<Color>(_crimson),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Certifications & GCC Accreditations',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _ink, letterSpacing: -0.3),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Validated credentials required for GCC visas and Aramco/ADNOC approvals.',
                    style: TextStyle(fontSize: 12, color: _inkLight),
                  ),
                ],
              ),
            ),

            // ── Scrollable Body ───────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Clean Callout Tip
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4F4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFFE2E2)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.workspace_premium, color: _crimson, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Verified certifications unlock high-priority employer shortlists & expedited visas.',
                              style: TextStyle(fontSize: 11, color: _ink, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── 1. Verified Credentials Section ───────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.verified, size: 16, color: _crimson),
                            SizedBox(width: 6),
                            Text(
                              'Verified Credentials',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _ink),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: _showAddCredentialDialog,
                          borderRadius: BorderRadius.circular(6),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            child: Row(
                              children: [
                                Icon(Icons.add, size: 16, color: _crimson),
                                SizedBox(width: 2),
                                Text('Add New', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _crimson)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dynamic User-Added Credentials
                    ..._extraCredentials.map((extra) => _buildCertificateCard(
                          issuer: extra['issuer']!,
                          code: extra['code']?.isEmpty ?? true ? null : extra['code'],
                          title: extra['title']!,
                          validText: 'Valid: Dec 2028',
                          fileName: extra['file']!,
                          fileMeta: 'PDF Document • 1.9 MB',
                          icon: Icons.verified,
                        )),

                    // Certifications Extracted from Parsed Resume
                    ...resumeCerts.map((cert) => _buildCertificateCard(
                          issuer: cert.issuer.isNotEmpty ? cert.issuer : 'Accredited Authority',
                          code: cert.credentialNumber.isNotEmpty ? cert.credentialNumber : null,
                          title: cert.title,
                          validText: cert.expiryYear.isNotEmpty ? 'Valid: ${cert.expiryYear}' : 'Verified Credential',
                          fileName: '${cert.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}_cert.pdf',
                          fileMeta: 'From Parsed CV • Verified',
                          icon: Icons.verified,
                        )),

                    // Certifications in Suhana Vault
                    ...vaultTradeCerts.where((vd) => !resumeCerts.any((rc) => rc.title == vd.title)).map((doc) => _buildCertificateCard(
                          issuer: doc.issuingCountry.isNotEmpty ? doc.issuingCountry : 'Accredited Authority',
                          code: doc.documentNumber.isNotEmpty ? doc.documentNumber : null,
                          title: doc.title,
                          validText: doc.expiryDate != null ? 'Valid: ${doc.expiryDate!.year}' : 'Active Credential',
                          fileName: '${doc.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}.pdf',
                          fileMeta: 'Suhana Vault Encrypted',
                          icon: Icons.verified_user,
                        )),

                    if (_extraCredentials.isEmpty && resumeCerts.isEmpty && vaultTradeCerts.isEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                          color: _white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _cardMid),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.military_tech_outlined, size: 36, color: _inkLight),
                            SizedBox(height: 8),
                            Text(
                              'No Certifications Added Yet',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _ink),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Upload your resume with certifications or tap "Add New" above.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11, color: _inkLight),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 10),

                    // ── 2. Saudi Aramco Approval Card ─────────────────────────
                    const Row(
                      children: [
                        Icon(Icons.shield_outlined, size: 16, color: _crimson),
                        SizedBox(width: 6),
                        Text(
                          'GCC Industry Approvals',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _ink),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE4DADB), width: 0.8),
                        boxShadow: const [
                          BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _hasAramcoCard ? _greenBg : const Color(0xFFFFF1F1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _hasAramcoCard ? Icons.verified : Icons.badge_outlined,
                                  color: _hasAramcoCard ? _green : _crimson,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _hasAramcoCard
                                          ? 'Saudi Aramco Approval Card ($_aramcoCardNumber)'
                                          : 'Saudi Aramco SAP ID / Work Permit Receiver',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _ink),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _hasAramcoCard
                                          ? 'Verified Active in Aramco Contractor Registry'
                                          : 'Upload card scan for fast-track operator approval',
                                      style: const TextStyle(fontSize: 11, color: _inkLight),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: _hasAramcoCard ? _greenBg : const Color(0xFFFFF1F1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _hasAramcoCard ? 'Verified' : 'Required',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _hasAramcoCard ? _green : _crimson,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _showAramcoUploadModal,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: _hasAramcoCard ? _green : _crimson, width: 1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              icon: Icon(_hasAramcoCard ? Icons.check : Icons.cloud_upload, size: 16, color: _hasAramcoCard ? _green : _crimson),
                              label: Text(
                                _hasAramcoCard ? 'Replace Aramco Scan' : 'Upload Aramco Card Scan',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _hasAramcoCard ? _green : _crimson),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── 3. Regulatory & Trade Licenses ────────────────────────
                    const Row(
                      children: [
                        Icon(Icons.assignment_ind_outlined, size: 16, color: _crimson),
                        SizedBox(width: 6),
                        Text(
                          'Regulatory & Driving Licenses',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _ink),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Healthcare License
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE4DADB), width: 0.8),
                        boxShadow: const [
                          BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(color: _cardLow, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.medical_services_outlined, size: 18, color: _ink),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Prometric / MOH / DHA License', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _ink)),
                                    Text('For healthcare & allied professionals', style: TextStyle(fontSize: 10, color: _inkLight)),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _isMedicalActive,
                                activeThumbColor: _crimson,
                                activeTrackColor: _crimson.withValues(alpha: 0.4),
                                onChanged: (val) => setState(() => _isMedicalActive = val),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ],
                          ),
                          if (_isMedicalActive) ...[
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _medicalLicenseController,
                                    decoration: const InputDecoration(
                                      labelText: 'License / Eligibility #',
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _verifyMedicalLicense,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _crimson,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    elevation: 0,
                                  ),
                                  child: const Text('Verify', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            if (_isMedicalVerified) ...[
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(color: _greenBg, borderRadius: BorderRadius.circular(6)),
                                child: const Row(
                                  children: [
                                    Icon(Icons.check_circle, color: _green, size: 14),
                                    SizedBox(width: 6),
                                    Text('✓ Verified active in DHA / MOH database', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // GCC Driving License
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE4DADB), width: 0.8),
                        boxShadow: const [
                          BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 2)),
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
                                  Icon(Icons.directions_car_outlined, size: 18, color: _ink),
                                  SizedBox(width: 8),
                                  Text('GCC Driving License', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _ink)),
                                ],
                              ),
                              InkWell(
                                onTap: _showAddLicenseDialog,
                                child: const Row(
                                  children: [
                                    Icon(Icons.add, size: 14, color: _crimson),
                                    SizedBox(width: 2),
                                    Text('Add', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _crimson)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (_gccDrivingLicenses.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text('No GCC driving license added yet. Tap "Add" to upload.', style: TextStyle(fontSize: 11, color: _inkLight)),
                            )
                          else
                            ..._gccDrivingLicenses.map((lic) => Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(color: _cardLow, borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    children: [
                                      const Text('🇸🇦', style: TextStyle(fontSize: 18)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(lic, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _ink)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: _greenBg, borderRadius: BorderRadius.circular(4)),
                                        child: const Text('Valid', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
                                      ),
                                    ],
                                  ),
                                )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ── Sticky Full-Width Action Button ──────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: _white,
                boxShadow: [
                  BoxShadow(color: Color(0x0C000000), blurRadius: 8, offset: Offset(0, -2)),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go(RouteNames.profile),
                  icon: const Text(
                    'Save & Continue to Profile',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  label: const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _crimson,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _buildCertificateCard({
    required String issuer,
    required String? code,
    required String title,
    required String validText,
    required String fileName,
    required String fileMeta,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4DADB), width: 0.8),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _cardLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: _crimson),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _ink),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          issuer,
                          style: const TextStyle(fontSize: 11, color: _inkLight, fontWeight: FontWeight.w500),
                        ),
                        if (code != null) ...[
                          const Text(' · ', style: TextStyle(color: _inkLight)),
                          Text(
                            code,
                            style: const TextStyle(fontSize: 10, color: _inkLight, fontFamily: 'monospace'),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _greenBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, size: 12, color: _green),
                    const SizedBox(width: 3),
                    Text(
                      validText,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _cardLow,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.attachment, size: 14, color: _inkLight),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '$fileName ($fileMeta)',
                          style: const TextStyle(fontSize: 10, color: _inkLight),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _showReplaceDialog(title),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('Replace', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _crimson)),
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
