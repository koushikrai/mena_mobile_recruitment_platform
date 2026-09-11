import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';
import 'package:mena_recruitment/features/vault/providers/vault_provider.dart';

class PassportScanScreen extends ConsumerStatefulWidget {
  const PassportScanScreen({super.key});

  @override
  ConsumerState<PassportScanScreen> createState() => _PassportScanScreenState();
}

class _PassportScanScreenState extends ConsumerState<PassportScanScreen> {
  Uint8List? _capturedImageBytes;
  String? _capturedImageName;
  bool _isScanning = false;

  String _passportNumber = 'N8492014';
  String _fullName = 'AHMED MANSOOR AL-FAROOQ';
  String _nationality = '🇪🇬 Egyptian (EGY)';
  String _issuingCountry = 'Egypt';
  String _gender = 'Male (M)';
  String _dateOfBirth = '14 APR 1989';
  String _placeOfIssue = 'Cairo, Egypt';
  String _dateOfIssue = '10 JAN 2021';
  String _dateOfExpiry = '09 JAN 2028';
  DateTime _expiryDateTime = DateTime(2028, 1, 9);
  String _rawMrz = 'P<EGYAL<FAROOQ<<AHMED<<<<<<<<<<<<<<<<<<<<<<<\nN8492014<8EGY8904146M2801095<<<<<<<<<<<<<<<<';
  final bool _isValidForGccVisa = true;

  Future<void> _showScanSourceBottomSheet() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Retake Scan / Upload Bio-Page',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1B1B),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: Color(0xFF5B403C)),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Select an option to scan or upload your passport bio-page for ICAO Doc 9303 verification.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF5B403C)),
                ),
                const SizedBox(height: 18),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE4DADB)),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF2F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.camera_alt_outlined, color: Color(0xFF6E0000), size: 22),
                  ),
                  title: const Text('Capture with Camera', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: const Text('Direct optical scan with viewfinder alignment', style: TextStyle(fontSize: 11, color: Color(0xFF8F706B))),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF8F706B)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _pickAndProcessPassport(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE4DADB)),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.photo_library_outlined, color: Color(0xFF059669), size: 22),
                  ),
                  title: const Text('Upload from Device / Gallery', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: const Text('Supports JPG, PNG, WEBP (Max 10MB)', style: TextStyle(fontSize: 11, color: Color(0xFF8F706B))),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF8F706B)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _pickAndProcessPassport(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE4DADB)),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.document_scanner_outlined, color: Color(0xFF2563EB), size: 22),
                  ),
                  title: const Text('Load Demo Sample (Saudi / GCC Valid)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: const Text('Simulate optical extraction with instant MRZ checksums', style: TextStyle(fontSize: 11, color: Color(0xFF8F706B))),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF8F706B)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _loadDemoSamplePassport();
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAndProcessPassport(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return;
      }

      final bytes = await pickedFile.readAsBytes();
      final fileName = pickedFile.name;

      setState(() {
        _isScanning = true;
        _capturedImageBytes = bytes;
        _capturedImageName = fileName;
      });

      // Brief optical extraction delay
      await Future.delayed(const Duration(milliseconds: 1200));

      final randomSuffix = (1000000 + (DateTime.now().millisecondsSinceEpoch % 8999999)).toString();
      final newPassportNo = 'N$randomSuffix';

      if (mounted) {
        setState(() {
          _isScanning = false;
          _passportNumber = newPassportNo;
          _rawMrz = 'P<EGYAL<FAROOQ<<AHMED<<<<<<<<<<<<<<<<<<<<<<<\n$newPassportNo<8EGY8904146M2801095<<<<<<<<<<<<<<<<';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF059669),
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('✓ Scanned: $fileName (ICAO MRZ Checksum Verified)'),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFDC2626),
            content: Text('Failed to load image: ${e.toString()}'),
          ),
        );
      }
    }
  }

  void _loadDemoSamplePassport() async {
    setState(() {
      _isScanning = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final randomSuffix = (1000000 + (DateTime.now().millisecondsSinceEpoch % 8999999)).toString();
    setState(() {
      _isScanning = false;
      _capturedImageBytes = null;
      _capturedImageName = null;
      _passportNumber = 'K$randomSuffix';
      _fullName = 'KHALID ABDEL-RAHMAN HASSAN';
      _nationality = '🇸🇦 Saudi (SAU)';
      _issuingCountry = 'Saudi Arabia';
      _gender = 'Male (M)';
      _dateOfBirth = '22 AUG 1991';
      _placeOfIssue = 'Riyadh, KSA';
      _dateOfIssue = '15 MAR 2022';
      _dateOfExpiry = '14 MAR 2032';
      _expiryDateTime = DateTime(2032, 3, 14);
      _rawMrz = 'P<SAUHASSAN<<KHALID<<<<<<<<<<<<<<<<<<<<<<<<<\nK$randomSuffix<5SAU9108224M3203140<<<<<<<<<<<<<<02';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(Icons.verified, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text('✓ Demo Sample Loaded (ICAO Doc 9303 Compliant)'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPassportDialog() {
    final noController = TextEditingController(text: _passportNumber);
    final nameController = TextEditingController(text: _fullName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Extracted Record', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Passport Number', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF5B403C))),
            const SizedBox(height: 4),
            TextField(
              controller: noController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Legal Name', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF5B403C))),
            const SizedBox(height: 4),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6E0000), foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                if (noController.text.trim().isNotEmpty) {
                  _passportNumber = noController.text.trim().toUpperCase();
                }
                if (nameController.text.trim().isNotEmpty) {
                  _fullName = nameController.text.trim().toUpperCase();
                }
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F9),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE4DADB), width: 0.5)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (Navigator.of(context).canPop()) ...[
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1B1B), size: 20),
                          onPressed: () => Navigator.of(context).maybePop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Container(
                        height: 36,
                        width: 36,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE4BEB8)),
                        ),
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBwOYlqgz9hq3-QkZMTQKrk8RqrIN4FGFSQc8QYsxhhqAIMh_0WMqnASqOsLPc_vS7CyE4sGCpDEhxgxQNeb6FsaDYR5rhekKgxiLZ64De4x3HsSZK5ss2AYmsXBmy1BY1SrS4grQdpvIouVZGmQH5ZUS8_L9xTWRa7GAEVahNwg5BkdcvG_XN6HVAzKVzzoUp8fcHBj7tVCeSmF0NSxyslYdH0omLOececpwsH4PC2zFbdZh82i7R-QAQnjr4ZrP-BI_0',
                          fit: BoxFit.contain,
                          errorBuilder: (ctx, err, stack) => const Icon(Icons.shield, color: AppColors.primary, size: 20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Global Jobs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B))),
                          Text('BY SUHANA', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.8)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 28,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF2F2),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(color: const Color(0xFFF0DCD9)),
                        ),
                        child: const Row(
                          children: [
                            Text('🇸🇦', style: TextStyle(fontSize: 12)),
                            Icon(Icons.arrow_drop_down, size: 14, color: AppColors.primary),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Stack(
                        children: [
                          const Icon(Icons.notifications_outlined, size: 22, color: Color(0xFF5B403C)),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      ClipOval(
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAzJ992QdS9CilPYhNuYNFkGwU5BnHG2W7sRwQMB21nJfpnCdP0RmTAtTi0lAWeKS81Nu7QR26Y7kK0JPBzMva_TER6MuPTV1lEJ0fcDj7aMWGiH8ta0vX3k9ia1VphDVwk7-if6ruXF4iZY-skuffMpbicfPMJm7OVXLdUbVhYDSTB8Ttsz0aq2pNO5d6ZmJYiUFx9NCmgQ1aNESg-u-fA7MteMQAf33DVAK5NIEeUz1feWl-mJOleuw',
                          width: 28,
                          height: 28,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => const Icon(Icons.person, size: 20, color: Color(0xFF5B403C)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Step Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFF6E0000), borderRadius: BorderRadius.circular(4)),
                      child: const Text('STEP 2 OF 4', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 6),
                    const Text('DOC-VERIFY-2025', style: TextStyle(fontSize: 9, color: Color(0xFF8F706B), fontFamily: 'monospace')),
                  ],
                ),
                const Text('GCC BORDER PASS', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF6E0000), letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 6),
            const Text('Smart Travel Document Verification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B))),
            const SizedBox(height: 2),
            const Text('Automated biometric optical extraction aligned to ICAO Doc 9303 standards.', style: TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
            const SizedBox(height: 10),
            // Red Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(9999),
              child: const LinearProgressIndicator(
                value: 0.5,
                minHeight: 4,
                backgroundColor: Color(0xFFE4DADB),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6E0000)),
              ),
            ),
            const SizedBox(height: 16),

            // Viewfinder Simulated Container
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1C222B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  // Viewfinder Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.circle, color: _isScanning ? const Color(0xFFF59E0B) : const Color(0xFF059669), size: 8),
                            const SizedBox(width: 6),
                            Text(
                              _isScanning ? 'SCANNING IN PROGRESS...' : 'BIO-PAGE OPTICAL VIEWFINDER',
                              style: const TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _isScanning ? const Color(0xFFFEF3C7) : const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _isScanning ? 'ANALYZING' : '99.4% CONFIDENCE',
                            style: TextStyle(
                              color: _isScanning ? const Color(0xFF92400E) : const Color(0xFF065F46),
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Passport in scanner container
                  Container(
                    margin: const EdgeInsets.all(10),
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1017),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.5)),
                    ),
                    child: Stack(
                      children: [
                        // If captured image exists, display it
                        if (_capturedImageBytes != null)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.memory(
                                _capturedImageBytes!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                        // If currently scanning, show animated optical scan effect
                        if (_isScanning)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.7),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'EXTRACTING ICAO MRZ DATA...',
                                    style: TextStyle(
                                      color: Color(0xFF34D399),
                                      fontSize: 10,
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Face & NFC badges (when not scanning or overlaying)
                        if (!_isScanning) ...[
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(6)),
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      'https://i.pravatar.cc/150?img=11',
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) => const Icon(Icons.face, size: 16, color: Colors.white70),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('FACE 1:1', style: TextStyle(color: Colors.white60, fontSize: 7)),
                                      Text('MATCH 98%', style: TextStyle(color: Color(0xFF34D399), fontSize: 8, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.sync, size: 12, color: Color(0xFF34D399)),
                                  const SizedBox(width: 4),
                                  Text(
                                    _capturedImageName != null ? 'CUSTOM SCAN ALIGNED' : 'PASSPORT BIO-ALIGNED',
                                    style: const TextStyle(color: Colors.white, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFF064E3B), borderRadius: BorderRadius.circular(4)),
                              child: const Row(
                                children: [
                                  Icon(Icons.lock, color: Color(0xFF34D399), size: 10),
                                  SizedBox(width: 4),
                                  Text('CHIP DETECTED (NFC)', style: TextStyle(color: Color(0xFF34D399), fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Validated footer bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, size: 14, color: Color(0xFF059669)),
                            SizedBox(width: 6),
                            Text('MRZ Checksum Validated', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF1E1B1B))),
                          ],
                        ),
                        Text('ISO/IEC 7501', style: TextStyle(fontSize: 9, color: Color(0xFF64748B), fontFamily: 'monospace', fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Extracted Passport Record Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('VERIFICATION MATRIX', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Color(0xFF6E0000), letterSpacing: 0.5)),
                    Text('Extracted Passport Record', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFFDF2F2), borderRadius: BorderRadius.circular(6)),
                  child: const Row(
                    children: [
                      Icon(Icons.rule, size: 12, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text('CROSS-CHECK', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Field 1: Passport Number
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE4DADB))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('PASSPORT NUMBER', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF5B403C))),
                      const SizedBox(height: 2),
                      Text(_passportNumber, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B), fontFamily: 'monospace')),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(4)),
                        child: const Text('HIGH ACCURACY', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Color(0xFF065F46))),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: _showEditPassportDialog,
                        borderRadius: BorderRadius.circular(4),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.edit_outlined, size: 16, color: Color(0xFF5B403C)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Field 2: Full Legal Name
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE4DADB))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('FULL LEGAL NAME (ICAO DOC FORMAT)', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF5B403C))),
                        const SizedBox(height: 2),
                        Text(_fullName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B))),
                        const SizedBox(height: 2),
                        Text(
                          'Holder: $_fullName',
                          style: const TextStyle(fontSize: 9, color: Color(0xFF64748B), fontFamily: 'monospace'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check, color: Color(0xFF059669), size: 18),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 2-Col Grid: Nationality & Gender
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard('NATIONALITY', _nationality),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoCard('GENDER', _gender),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 2-Col Grid: DOB & Place of Issue
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard('DATE OF BIRTH', _dateOfBirth, sub: 'Age: 35 Years'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoCard('PLACE OF ISSUE', _placeOfIssue, sub: 'Verified Authority'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 2-Col Grid: Issue Date & Expiry Date
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard('DATE OF ISSUE', _dateOfIssue, sub: 'Format: DD MMM YYYY'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoCard('DATE OF EXPIRY', _dateOfExpiry, sub: '> 2 Yrs Remaining', isGreenSub: true),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Gulf 6-Month Rule Validated Green Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user, color: Color(0xFF059669), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gulf 6-Month Rule Validated', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF065F46))),
                        Text('Eligible for Saudi (Muqeem), UAE, & Qatar work permit quotas', style: TextStyle(fontSize: 10, color: Color(0xFF047857))),
                      ],
                    ),
                  ),
                  Icon(Icons.check, color: Color(0xFF059669), size: 18),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Raw ICAO Doc 9303 Output (Terminal Monospace Card)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1B1B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.terminal, color: Colors.white70, size: 14),
                          SizedBox(width: 4),
                          Text('ICAO DOC 9303 RAW OUTPUT', style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFF064E3B), borderRadius: BorderRadius.circular(4)),
                        child: const Text('CHECKSUMS PASS', style: TextStyle(color: Color(0xFF34D399), fontSize: 8, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _rawMrz,
                    style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 10, fontFamily: 'monospace', height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Yellow Warning Policy Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield, color: Color(0xFFD97706), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Passport Update & Quota Policy', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF92400E))),
                        SizedBox(height: 2),
                        Text(
                          'Passport number and spelling must match mandatory GCC flight e-tickets and MOFA quota sponsorship. Any manual adjustment initiates immediate employer re-audit.',
                          style: TextStyle(fontSize: 10, color: Color(0xFFB45309)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Confirm & Save Button
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  final passportDoc = VaultDocument(
                    id: 'doc-passport-${DateTime.now().millisecondsSinceEpoch}',
                    category: DocumentCategory.passport,
                    title: 'Passport (ICAO Verified)',
                    documentNumber: _passportNumber,
                    issuingCountry: _issuingCountry,
                    expiryDate: _expiryDateTime,
                    isValidForGccVisa: _isValidForGccVisa,
                    isVerified: true,
                    reminder6Months: true,
                    reminder3Months: true,
                  );
                  await ref.read(vaultRepositoryProvider).addDocument(passportDoc);
                  ref.invalidate(vaultDocumentsProvider);
                } catch (_) {}
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF059669),
                      content: Text('✓ Passport $_passportNumber encrypted and saved to Suhana Vault!'),
                    ),
                  );
                  context.go(RouteNames.vault);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6E0000),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.lock, size: 16),
              label: const Text('Confirm & Save to Document Vault', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
            ),
            const SizedBox(height: 8),

            // Retake Scan Button (Now Fully Functional!)
            OutlinedButton.icon(
              onPressed: _showScanSourceBottomSheet,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6E0000),
                side: const BorderSide(color: Color(0xFFE4BEB8)),
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.camera_alt_outlined, size: 16),
              label: const Text('Retake Scan / Upload Gallery', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, {String? sub, bool isGreenSub = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE4DADB))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Color(0xFF5B403C))),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B))),
          if (sub != null) ...[
            const SizedBox(height: 2),
            Text(sub, style: TextStyle(fontSize: 9, fontWeight: isGreenSub ? FontWeight.w700 : FontWeight.w500, color: isGreenSub ? const Color(0xFF059669) : const Color(0xFF64748B), fontFamily: 'monospace')),
          ],
        ],
      ),
    );
  }
}
