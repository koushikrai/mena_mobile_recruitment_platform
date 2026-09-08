import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';

import 'package:mena_recruitment/features/vault/domain/certification_entity.dart';

abstract class VaultRepository {
  Future<List<VaultDocument>> getDocuments();
  Future<void> addDocument(VaultDocument document);
  Future<void> deleteDocument(String documentId);
  Future<VaultDocument?> getPassport();
  Future<List<Certification>> getCertifications();
  Future<void> addCertification(Certification certification);
}
