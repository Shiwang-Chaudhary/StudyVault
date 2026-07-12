import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:study_vault/core/constans/api_constants.dart';
import 'package:study_vault/features/auth/data/user_model.dart';

class AuthRepoProvider {
  AuthRepoProvider(this.firebaseAuth, this.dio);

  final Dio dio;
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  Future<void> initialize() async {}

  Future<UserModel> sigInWithGoogle() async {
    try {
      //Initialize the GoogleSignIn instance
      await googleSignIn.initialize();
      //Sign in pannel opens:
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      //Ask the user for permission to access their Google account
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      //Check if the ID token is null, if it is, throw an exception
      if (googleAuth.idToken == null) {
        throw FirebaseAuthException(
          code: 'missing-id-token',
          message: 'Google did not return an ID token.',
        );
      }
      //Create a new credential using the ID token and sign in with it
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await firebaseAuth.signInWithCredential(credential);
      final user = await syncWithBackend();
      return user;
    } catch (e, st) {
      log("ERROR: $e");
      log(st.toString());
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: e.toString(),
      );
    }
  }

  Future<UserModel> syncWithBackend() async {
    log("Syncing with backend for user: ${firebaseAuth.currentUser?.uid}");
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception("User is not authenticated");
      }
      final token = await currentUser.getIdToken();
      final response = await dio.post(
        ApiConstants.googleLogin,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Backend sync failed: ${e.message}');
    }
  }

  //Keep track of the authentication state changes and return the current user
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  //Get the current user from FirebaseAuth
  User? get currentUser => firebaseAuth.currentUser;

  Future<String?> get getIdToken async {
    return firebaseAuth.currentUser?.getIdToken();
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }
}
