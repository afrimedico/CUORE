import 'package:firebase_auth/firebase_auth.dart';
import 'package:ghala/profile/app.dart';
import 'package:google_sign_in/google_sign_in.dart';

String userId = '0';
String userName = 'unknown';
String userEmail = 'nobody';
String userImageUrl = '';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount == null) {
    // 認証画面を何もせずに閉じたとき
    return null;
  }

  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  var auth = await _auth.signInWithCredential(credential);

  final FirebaseUser user = auth.user;
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);
  userId = user.uid;
  userName = user.displayName;
  userEmail = user.email;
  userImageUrl = user.photoUrl;
  if (userName.contains(" ")) {
    userName = userName.substring(0, userName.indexOf(" "));
  }

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  userId = '0';
  userName = 'unknown';
  userEmail = 'nobody';
  userImageUrl = '';

  // プロファイル設定
  var user = await App.getProfile();
  if (user['name'] != null) {
    user['name'] = null;
  }
  await App.setProfile(user);
  await googleSignIn.signOut();

  print("User Sign Out");
}
