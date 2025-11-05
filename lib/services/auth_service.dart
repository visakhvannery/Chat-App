import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.ref();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<AppUser?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user!;

    // 🔹 Get FCM token
    final token = await _fcm.getToken();

    // Save user info to Firebase
    await _db.child('users/${user.uid}').set({
      'uid': user.uid,
      'name': user.displayName,
      'email': user.email,
      'photoUrl': user.photoURL,
      'fcmToken': token,
      'lastSeen': ServerValue.timestamp,
    });

    return AppUser(uid: user.uid, name: user.displayName ?? '', email: user.email ?? '', photoUrl: user.photoURL);
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }
}
