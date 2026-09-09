import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';
import 'package:mena_recruitment/features/vault/domain/passport_mrz_entity.dart';
import 'package:mena_recruitment/features/vault/domain/certification_entity.dart';

class MockVaultData {
  static VaultDocument mockPassport = VaultDocument(
    id: 'pass-123',
    category: DocumentCategory.passport,
    title: 'Indian Passport',
    documentNumber: 'Z1234567',
    issuingCountry: 'India',
    expiryDate: DateTime.now().add(const Duration(days: 365 * 4)),
    isValidForGccVisa: true,
    isVerified: true,
    reminder6Months: true,
  );

  static PassportMRZ mockPassportMRZ = PassportMRZ(
    rawMrz: 'P<INDNAME<<GIVEN<<<<<<<<<<<<<<<<<<<<<<<<<<<\nZ1234567<5IND8001014M2601010<<<<<<<<<<<<<<00',
    passportNumber: 'Z1234567',
    surname: 'NAME',
    givenNames: 'GIVEN',
    nationality: 'IND',
    dateOfBirth: DateTime(1980, 1, 1),
    gender: 'M',
    expiryDate: DateTime.now().add(const Duration(days: 365 * 4)),
    hasSixMonthsValidity: true,
  );

  static List<VaultDocument> mockDocuments = [
    mockPassport,
    const VaultDocument(
      id: 'doc-001',
      category: DocumentCategory.educationAttestation,
      title: 'B.Tech Degree Certificate',
      documentNumber: 'EDU-99231',
      issuingCountry: 'India',
      isVerified: true,
    ),
    const VaultDocument(
      id: 'doc-002',
      category: DocumentCategory.educationAttestation,
      title: 'Master Degree Certificate',
      documentNumber: 'EDU-99232',
      issuingCountry: 'India',
      isVerified: false,
    ),
    VaultDocument(
      id: 'doc-003',
      category: DocumentCategory.medicalGamca,
      title: 'GAMCA Medical Report',
      documentNumber: 'GAM-88331',
      issuingCountry: 'India',
      expiryDate: DateTime.now().add(const Duration(days: 60)),
      isVerified: true,
    ),
    VaultDocument(
      id: 'doc-004',
      category: DocumentCategory.policeClearance,
      title: 'Police Clearance Certificate',
      documentNumber: 'PCC-77332',
      issuingCountry: 'India',
      expiryDate: DateTime.now().add(const Duration(days: 120)),
      isVerified: true,
    ),
  ];

  static List<Certification> mockCertifications = [
    Certification(
      id: 'cert-1',
      title: 'NEBOSH IGC',
      category: CertificationCategory.safetyNeboshOsha,
      issuingAuthority: 'NEBOSH UK',
      credentialId: 'NEB-12345',
      validFrom: DateTime(2020, 5, 12),
      isVerified: true,
    ),
    Certification(
      id: 'cert-2',
      title: 'DHA Registered Nurse',
      category: CertificationCategory.medicalDhaMoh,
      issuingAuthority: 'Dubai Health Authority',
      credentialId: 'DHA-RN-9988',
      validFrom: DateTime(2021, 8, 20),
      validUntil: DateTime.now().add(const Duration(days: 400)),
      isVerified: true,
    ),
    Certification(
      id: 'cert-3',
      title: 'SCE Member',
      category: CertificationCategory.engineeringSCE,
      issuingAuthority: 'Saudi Council of Engineers',
      credentialId: 'SCE-5543',
      validFrom: DateTime(2022, 2, 10),
      validUntil: DateTime.now().add(const Duration(days: 150)),
      isVerified: false,
    ),
  ];
}
