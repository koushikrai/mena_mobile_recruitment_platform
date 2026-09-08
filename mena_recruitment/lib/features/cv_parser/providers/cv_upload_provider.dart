import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../data/cv_parser_repository_impl.dart';
import '../domain/parsed_cv_entity.dart';

final cvParserRepositoryProvider = Provider((ref) => CVParserRepositoryImpl());

final isParsingProvider = StateProvider<bool>((ref) => false);
final parsedCVProvider = StateProvider<ParsedCV?>((ref) => null);

class CVUploadNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  CVUploadNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> uploadCV(File file) async {
    state = const AsyncValue.loading();
    ref.read(isParsingProvider.notifier).state = true;
    try {
      final repo = ref.read(cvParserRepositoryProvider);
      final parsed = await repo.uploadCV(file);
      ref.read(parsedCVProvider.notifier).state = parsed;
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      ref.read(isParsingProvider.notifier).state = false;
    }
  }
}

final cvUploadProvider = StateNotifierProvider<CVUploadNotifier, AsyncValue<void>>((ref) {
  return CVUploadNotifier(ref);
});
