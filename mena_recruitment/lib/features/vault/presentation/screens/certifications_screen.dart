import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CertificationsScreen extends ConsumerStatefulWidget {
  const CertificationsScreen({super.key});

  @override
  ConsumerState<CertificationsScreen> createState() => _CertificationsScreenState();
}

class _CertificationsScreenState extends ConsumerState<CertificationsScreen> {
  bool _isMedicalActive = false;
  bool _isMedicalVerified = false;
  final TextEditingController _medicalLicenseController = TextEditingController(text: 'DHA-P-0029319');

  bool _hasAramcoCard = false;
  String _aramcoCardNumber = 'SAP-772918';

  final List<String> _gccDrivingLicenses = [
    'Saudi Driving License (Valid) • Exp: 2028',
  ];

  final List<Map<String, String>> _extraCredentials = [];

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
        title: const Text('Add Verified Credential', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Certificate Title', border: OutlineInputBorder(), isDense: true)),
            const SizedBox(height: 10),
            TextField(controller: issuerCtrl, decoration: const InputDecoration(labelText: 'Issuing Body', border: OutlineInputBorder(), isDense: true)),
            const SizedBox(height: 10),
            TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Credential # (optional)', border: OutlineInputBorder(), isDense: true)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _extraCredentials.add({
                    'title': titleCtrl.text.trim(),
                    'issuer': issuerCtrl.text.trim().isEmpty ? 'Accredited Board' : issuerCtrl.text.trim(),
                    'code': codeCtrl.text.trim(),
                    'file': '${titleCtrl.text.trim().toLowerCase().replaceAll(" ", "_")}_cert.pdf',
                  });
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✓ Credential added to Suhana Verified Vault!'), backgroundColor: Color(0xFF059669)),
                );
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6E0000), foregroundColor: Colors.white),
            child: const Text('Add to Vault'),
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
            Text('Select a new PDF or JPEG scan from your device.', style: TextStyle(fontSize: 12, color: Color(0xFF5B403C))),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload_outlined, size: 36, color: Color(0xFF6E0000)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('✓ Successfully replaced document for $certName!'), backgroundColor: const Color(0xFF059669)),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6E0000), foregroundColor: Colors.white),
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
                Icon(Icons.badge, color: Color(0xFF6E0000)),
                SizedBox(width: 8),
                Text('Upload Saudi Aramco Approval Card', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload front and back scan of your Aramco SAP ID card or Safety Work Permit Receiver card.',
              style: TextStyle(fontSize: 12, color: Color(0xFF5B403C)),
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
                  const SnackBar(content: Text('✓ Saudi Aramco Approval Card verified & attached!'), backgroundColor: Color(0xFF059669)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6E0000),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Confirm Upload & Verify Card', style: TextStyle(fontWeight: FontWeight.bold)),
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
                CircularProgressIndicator(color: Color(0xFF6E0000)),
                SizedBox(width: 16),
                Text('Verifying with DHA/MOH Healthcare Registry...'),
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
      SnackBar(content: Text('✓ License $text verified active in MHRSD & DHA Registry!'), backgroundColor: const Color(0xFF059669)),
    );
  }

  void _showAddLicenseDialog() {
    final nameCtrl = TextEditingController(text: 'UAE Light Vehicle License (Valid) • Exp: 2029');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add GCC License', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'License details', border: OutlineInputBorder(), isDense: true),
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
                const SnackBar(content: Text('✓ Added GCC driving license!'), backgroundColor: Color(0xFF059669)),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6E0000), foregroundColor: Colors.white),
            child: const Text('Add License'),
          ),
        ],
      ),
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
            // Progress Header
            Container(
              color: cardLowest,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'STEP 3 OF 4: GCC TRADE & SAFETY LICENSES',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: textSecondary,
                        ),
                      ),
                      Text(
                        '75% Completed',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: primaryCrimson,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.75,
                      minHeight: 5,
                      backgroundColor: cardHigh,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryCrimson),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(Icons.verified_user, size: 14, color: primaryCrimson),
                      SizedBox(width: 4),
                      Text(
                        'GLOBAL JOBS BY SUHANA',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Certifications & GCC Accreditations',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textOnSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Gulf employers require validated certificates for visa quotas and Aramco/ADNOC approvals.',
                    style: TextStyle(fontSize: 12, color: textSecondary),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Smart Verification Callout Banner
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
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: primaryCrimson,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.workspace_premium, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Priority Shortlist Acceleration',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: primaryCrimson,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Upload certificates with valid expiration dates to unlock high-priority GCC interview shortlists and fast-tracked visa clearances.',
                                  style: TextStyle(fontSize: 11, color: textOnSurface, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section: Pre-identified Certificates
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Verified Credentials',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textOnSurface),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDFE2EC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Extracted from CV',
                                style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: _showAddCredentialDialog,
                          child: const Row(
                            children: [
                              Icon(Icons.add, size: 16, color: primaryCrimson),
                              SizedBox(width: 2),
                              Text('Add New', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryCrimson)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Additional user-added credentials
                    ..._extraCredentials.map((extra) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildCertificateCard(
                            issuer: extra['issuer']!,
                            code: extra['code']?.isEmpty ?? true ? null : extra['code'],
                            title: extra['title']!,
                            validText: 'Valid: Dec 2028',
                            fileName: extra['file']!,
                            fileMeta: 'PDF Document • 1.9 MB',
                            icon: Icons.verified,
                          ),
                        )),

                    // Certificate 1: NEBOSH
                    _buildCertificateCard(
                      issuer: 'NEBOSH UK',
                      code: '#NEB-0049281',
                      title: 'NEBOSH International General Certificate (IGC)',
                      validText: 'Valid: Nov 2027',
                      fileName: 'nebosh_igc_cert_ahmed.pdf',
                      fileMeta: 'PDF Document • 2.4 MB',
                      icon: Icons.picture_as_pdf,
                    ),
                    const SizedBox(height: 12),

                    // Certificate 2: OPITO BOSIET
                    _buildCertificateCard(
                      issuer: 'OPITO Approved Training Center',
                      code: null,
                      title: 'OPITO BOSIET + CA-EBS (Offshore Survival)',
                      validText: 'Valid: Jun 2026',
                      fileName: 'bosiet_card_scan.jpg',
                      fileMeta: 'JPEG Image • 1.8 MB',
                      icon: Icons.sailing,
                    ),
                    const SizedBox(height: 12),

                    // Certificate 3: Aramco Card Missing / Action Required
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _hasAramcoCard ? const Color(0xFFD1FAE5) : const Color(0xFFFFDAD6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _hasAramcoCard ? Icons.verified : Icons.priority_high,
                                  size: 13,
                                  color: _hasAramcoCard ? const Color(0xFF065F46) : const Color(0xFFBA1A1A),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _hasAramcoCard ? 'Verified Active Aramco Approval' : 'Document Scan Missing',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _hasAramcoCard ? const Color(0xFF065F46) : const Color(0xFFBA1A1A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _hasAramcoCard ? 'Saudi Aramco Approval Card ($_aramcoCardNumber)' : 'Saudi Aramco SAP ID / Safety Work Permit Receiver',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textOnSurface),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _hasAramcoCard
                                ? '✓ Verified in Aramco Contractor Registry. Valid for Yanbu & Jubail operations.'
                                : 'Identified in CV text. Please upload front/back scan of your Aramco Approval Card to verify.',
                            style: const TextStyle(fontSize: 11, color: textSecondary),
                          ),
                          const SizedBox(height: 12),

                          // Upload Box with Red/Green Outline
                          InkWell(
                            onTap: _showAramcoUploadModal,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: _hasAramcoCard ? const Color(0xFFF0FDF4) : const Color(0xFFFFF6F6),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _hasAramcoCard ? const Color(0xFF059669) : containerCrimson.withValues(alpha: 0.35),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: cardLowest,
                                    child: Icon(
                                      _hasAramcoCard ? Icons.check_circle : Icons.cloud_upload,
                                      color: _hasAramcoCard ? const Color(0xFF059669) : primaryCrimson,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _hasAramcoCard ? 'Replace Aramco Card Scan' : '+ Upload Aramco Card',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: _hasAramcoCard ? const Color(0xFF059669) : primaryCrimson,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _hasAramcoCard ? 'aramco_approval_card_scan.pdf • 1.6 MB' : 'JPEG, PNG, or PDF (Max 10MB)',
                                    style: const TextStyle(fontSize: 10, color: textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Section: GCC Regulatory Licenses
                    const Row(
                      children: [
                        Icon(Icons.badge, size: 18, color: primaryCrimson),
                        SizedBox(width: 6),
                        Text(
                          'GCC Regulatory Licenses',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textOnSurface),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Medical & Prometric Toggle Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDEE2ED),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.medical_services, size: 18, color: Color(0xFF171C23)),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Prometric / MOH / DHA License',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textOnSurface),
                                    ),
                                    Text(
                                      'Healthcare and allied health practitioners',
                                      style: TextStyle(fontSize: 10, color: textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _isMedicalActive,
                                activeThumbColor: primaryCrimson,
                                onChanged: (val) => setState(() => _isMedicalActive = val),
                              ),
                            ],
                          ),
                          if (_isMedicalActive) ...[
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'LICENSE / ELIGIBILITY NUMBER',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textSecondary, letterSpacing: 0.8),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: cardLow,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: TextField(
                                          controller: _medicalLicenseController,
                                          decoration: const InputDecoration(
                                            hintText: 'e.g. DHA-P-0029319',
                                            hintStyle: TextStyle(fontSize: 12, color: textSecondary),
                                            border: InputBorder.none,
                                            isDense: true,
                                          ),
                                          style: const TextStyle(fontSize: 12, color: textOnSurface),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: _verifyMedicalLicense,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryCrimson,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                        elevation: 0,
                                      ),
                                      child: const Text('Verify', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ),
                                  ],
                                ),
                                if (_isMedicalVerified) ...[
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD1FAE5),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Color(0xFF059669), size: 14),
                                        SizedBox(width: 6),
                                        Text('✓ Verified Active in MHRSD / DHA Practitioner Database', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // GCC Driving License Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Color(0xFFDEE2ED),
                                child: Icon(Icons.directions_car, size: 18, color: Color(0xFF171C23)),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'GCC Driving License',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textOnSurface),
                                  ),
                                  Text(
                                    'Transport & heavy equipment qualification',
                                    style: TextStyle(fontSize: 10, color: textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          ..._gccDrivingLicenses.map((lic) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: cardLow,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('🇸🇦', style: TextStyle(fontSize: 20)),
                                        const SizedBox(width: 8),
                                        Text(lic, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textOnSurface)),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5E9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.check, size: 12, color: Color(0xFF1B5E20)),
                                          SizedBox(width: 3),
                                          Text('Valid', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),

                          const SizedBox(height: 4),
                          InkWell(
                            onTap: _showAddLicenseDialog,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                color: cardHigh,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_circle, size: 16, color: textOnSurface),
                                  SizedBox(width: 6),
                                  Text(
                                    '+ Add License (UAE / Qatar / Kuwait)',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textOnSurface),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: cardLowest,
                boxShadow: [
                  BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: cardHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_back, color: textOnSurface, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/vault'),
                        icon: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                        label: const Text(
                          'Continue to Profile Summary',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: containerCrimson,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F3FD),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.domain, size: 12, color: Color(0xFF5A5F67)),
                          const SizedBox(width: 4),
                          Text(
                            issuer,
                            style: const TextStyle(fontSize: 10, color: Color(0xFF5A5F67), fontWeight: FontWeight.w600),
                          ),
                          if (code != null) ...[
                            const SizedBox(width: 4),
                            const Text('•', style: TextStyle(fontSize: 10, color: Color(0xFF5A5F67))),
                            const SizedBox(width: 4),
                            Text(
                              code,
                              style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: Color(0xFF5A5F67)),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF181C23)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 12, color: Color(0xFF1B5E20)),
                    const SizedBox(width: 4),
                    Text(
                      validText,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFE2EC),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, size: 18, color: const Color(0xFF6E0000)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF181C23)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        fileMeta,
                        style: const TextStyle(fontSize: 10, color: Color(0xFF5A5F67)),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _showReplaceDialog(title),
                  child: const Text('Replace', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6E0000))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

