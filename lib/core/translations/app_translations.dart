import 'package:get/get.dart';
import 'package:lumica_app/core/translations/en.dart';
import 'package:lumica_app/core/translations/id.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_EN': EnTranslations.translations,
    'id_ID': IdTranslations.translations,
  };
}
