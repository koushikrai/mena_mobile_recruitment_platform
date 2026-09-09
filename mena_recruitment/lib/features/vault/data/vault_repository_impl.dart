import 'package:flutter/foundation.dart';
import 'package:mena_recruitment/core/network/api_client.dart';
import 'package:mena_recruitment/core/network/api_endpoints.dart';
import 'package:mena_recruitment/features/vault/domain/vault_repository.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';
import 'package:mena_recruitment/features/vault/domain/certification_entity.dart';
import 'package:mena_recruitment/features/vault/data/mock_vault_data.dart';

class VaultRepositoryImpl implements VaultRepository {
  final ApiClient _apiClient = ApiClient();
  final List<VaultDocument> _documents = List.from(MockVaultData.mockDocuments);
  final List<Certification> _certifications = List.from(MockVaultData.mockCertifications);

  @override
  Future<List<VaultDocument>> getDocuments() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.vaultDocuments);
      if (response.statusCode == 200 && response.data is List) {
        final rawList = response.data as List;
        if (rawList.isNotEmpty) {
          final liveDocs = rawList
              .map((json) => VaultDocument.fromJson(json as Map<String, dynamic>))
              .toList();
          return liveDocs;
        }
      }
    } catch (e) {
      debugPrint('[VaultRepo] Backend getDocuments error, falling back: $e');
    }

    await Future.delayed(const Duration(milliseconds: 300));
    return _documents;
  }

  @override
  Future<void> addDocument(VaultDocument document) async {
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
