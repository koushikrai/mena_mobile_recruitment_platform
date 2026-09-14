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

  static List<VaultDocument> mockDocuments = [];

  static List<Certification> mockCertifications = [];
}
