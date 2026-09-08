import 'package:mena_recruitment/features/vault/domain/vault_repository.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';
import 'package:mena_recruitment/features/vault/domain/certification_entity.dart';
import 'package:mena_recruitment/features/vault/data/mock_vault_data.dart';

class VaultRepositoryImpl implements VaultRepository {
  final List<VaultDocument> _documents = List.from(MockVaultData.mockDocuments);
  final List<Certification> _certifications = List.from(MockVaultData.mockCertifications);

  @override
  Future<List<VaultDocument>> getDocuments() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _documents;
  }

  @override
  Future<void> addDocument(VaultDocument document) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _documents.add(document);
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _documents.removeWhere((doc) => doc.id == documentId);
  }

  @override
  Future<VaultDocument?> getPassport() async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _documents.firstWhere((doc) => doc.category == DocumentCategory.passport);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Certification>> getCertifications() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _certifications;
  }

  @override
  Future<void> addCertification(Certification certification) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _certifications.add(certification);
  }
}
