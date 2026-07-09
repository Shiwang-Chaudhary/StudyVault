import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepoProvider {
  AuthRepoProvider(this.firebaseAuth);

  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  Future<void> initialize() async {}

  Future<User> sigInWithGoogle() async {
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
      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      return userCredential.user!;
    } on GoogleSignInException catch (e) {
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: e.toString(),
      );
    }
  }

  //Keep track of the authentication state changes and return the current user
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  //Get the current user from FirebaseAuth
  User? get currentUser => firebaseAuth.currentUser;

  Future<String?>? get getIdToken => firebaseAuth.currentUser?.getIdToken();

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
