class AppLocalStorage {
  AppLocalStorage._();
  static final _instance = AppLocalStorage._();

  factory AppLocalStorage.instance() => _instance;

  String getLanguage() {
    return 'th';
  }
}

