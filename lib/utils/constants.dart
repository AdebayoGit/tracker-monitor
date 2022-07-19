class AppConstants{
  static final AppConstants _instance = AppConstants._();

  AppConstants._();

  factory AppConstants() {
    return _instance;
  }

  static const String mapsApiKey = 'AIzaSyAxQD56E_hNpRMiu84kR8OjLG3afTzC00o';

  static const String addNewDriverBody = '''Create a new Driver''';
  static const String driverCatalogueBody = '''View drivers list 
and comprehensive data on each one''';
}