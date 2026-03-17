import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginVM extends ChangeNotifier {
  // Do NOT hardcode clientId — let platform auto-detect from Firebase config
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '827880147744-0r7hnf2dpm5nuj1p44k42c6ijq5tlrni.apps.googleusercontent.com',
    scopes: ['openid', 'email', 'profile'],
  );
  
  GoogleSignInAccount? _googleUser; // cached Google account for app lifetime
  bool _silentAttempted = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isLoading = false;
  String? errorMessage;

  // Reactive profile fields
  String? profilePhoto;
  String? displayName;
  User? currentUser;
  String? email;
  LoginVM() {
    _initializeSignIn();
  }

  /// 🔄 Load existing user when app opens
  /// Initialize sign-in state once at startup. Attempts a single silent sign-in
  /// and caches the Google account in `_googleUser` for reuse throughout the app.
  Future<void> _initializeSignIn() async {
    if (_silentAttempted) return;
    _silentAttempted = true;

    try {
      // First, try to get an already-signed-in Firebase user
      currentUser = _firebaseAuth.currentUser;

      // If no firebase user, attempt a single silent Google sign-in
      if (currentUser == null) {
        _googleUser = await _googleSignIn.signInSilently();
        if (_googleUser != null) {
          final googleAuth = await _googleUser!.authentication;
          final credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          );
          final userCredential = await _firebaseAuth.signInWithCredential(credential);
          currentUser = userCredential.user;
        }
      }

      if (currentUser != null) {
        profilePhoto = currentUser!.photoURL?.replaceFirst('http://', 'https://');
        displayName = currentUser!.displayName;
        email = currentUser!.email;
        notifyListeners();
      }
    } catch (_) {
      // ignore silent init errors — we'll let interactive sign-in handle them
    }
  }

  /// 🔐 Google Sign-In
  Future<bool> signInWithGoogle() async {
    try {
      isLoading = true;
      notifyListeners();

      // Reuse cached account if we have one; otherwise perform interactive sign-in
      GoogleSignInAccount? googleUser = _googleUser ?? await _googleSignIn.signIn();

      if (googleUser == null) {
        return false;
      }

      // Cache for future use
      _googleUser = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      currentUser = userCredential.user;

      // Get profile data directly from Google account (more reliable)
      profilePhoto = googleUser.photoUrl?.replaceFirst('http://', 'https://');
      displayName = googleUser.displayName;
      email= googleUser.email;
      debugPrint('✅ Signed in: $displayName');
      debugPrint('📸 Profile photo: $profilePhoto');

      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🚪 Logout
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();

    currentUser = null;
    profilePhoto = null;
    displayName = null;
    notifyListeners();
  }
}
