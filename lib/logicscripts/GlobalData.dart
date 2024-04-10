class GlobalData {
  // Singleton instance
  static final GlobalData _instance = GlobalData._internal();

  // Private constructor
  GlobalData._internal();

  // Singleton accessor
  factory GlobalData() => _instance;

  // Member variables
  String? email;
  String? secret_key;
  // List<int>? dataList;

  // Methods to manipulate the data
  void setEmail(String data) {
    email = data;
  }

  String? getEmail() {
    return email;
  }

  void setSecret(String data) {
    secret_key = data;
  }

}
