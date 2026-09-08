import 'dart:io';
import 'parsed_cv_entity.dart';

abstract class CVParserRepository {
  Future<ParsedCV> uploadCV(File file);
  Future<void> saveParsedCV(ParsedCV cv);
}
