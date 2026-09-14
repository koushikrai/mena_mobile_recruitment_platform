import 'package:mena_recruitment/features/vault/domain/vault_repository.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';
import 'package:mena_recruitment/features/vault/domain/certification_entity.dart';

class VaultRepositoryImpl implements VaultRepository {
  static final VaultRepositoryImpl _instance = VaultRepositoryImpl._internal();
  factory VaultRepositoryImpl() => _instance;
  VaultRepositoryImpl._internal();

  final List<VaultDocument> _documents = [];
  final List<Certification> _certifications = [];

  @override
  Future<List<VaultDocument>> getDocuments() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_documents);
  }

  @override
  Future<void> addDocument(VaultDocument document) async {
    if (document.category == DocumentCategory.passport) {
      _documents.removeWhere((doc) => doc.category == DocumentCategory.passport);
    } else {
      _documents.removeWhere((doc) => doc.id == document.id);
    }
    _documents.add(document);
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    _documents.removeWhere((doc) => doc.id == documentId);
  }

  @override
  Future<VaultDocument?> getPassport() async {
    final docs = await getDocuments();
    try {
      return docs.firstWhere((doc) => doc.category == DocumentCategory.passport);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Certification>> getCertifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _certifications;
  }

  @override
  Future<void> addCertification(Certification certification) async {
    _certifications.add(certification);
  }
}
