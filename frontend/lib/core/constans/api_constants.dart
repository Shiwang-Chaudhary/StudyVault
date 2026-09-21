class ApiConstants {
  static const String baseUrl = "http://192.168.1.4:3000";
  // static const String baseUrl = "https://study-vault-backend-29bx.onrender.com";

  static const String googleLogin = "/api/auth/google";
  static const String onboarding = "/api/auth/onboarding";
  static const String uploadFile = "/api/notes/"; //POST
  static const String getUserNotes = "/api/notes/my";
  static const String getFilteredNotes = "/api/notes/"; //GET
  static const String downloadNote = "/api/noteId/download";
  static const String getBookmark = "/api/notes/my/bookmarks";
  static const String addBookmark = "/api/notes/noteId/bookmark";
  static const String deleteBookmark = "/api/notes/noteId/bookmark";
  static String trending = "/api/notes/trending";
  static String recommended = "/api/notes/recommended";
  static String rateNote(String noteId) => "/api/notes/$noteId/rating";
  static String fetchRatings(String noteId) => "/api/notes/$noteId/ratings";
}
