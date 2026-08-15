class ApiConstants {
  static const String baseUrl = "http://192.168.1.7:3000";
  // static const String baseUrl = "https://study-vault-backend-29bx.onrender.com";

  static const String googleLogin = "/api/auth/google";
  static const String onboarding = "/api/auth/onboarding";
  static const String uploadFile = "/api/notes/"; //POST
  static const String getUserNotes = "/api/notes/my";
  static const String getFilteredNotes = "/api/notes/"; //GET
  static const String downloadNote = "/api/noteId/download";
}
