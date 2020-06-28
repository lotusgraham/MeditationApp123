import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login with google
  Future<FirebaseUser> handleGoogleSignIn() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn().catchError((e) => print(e));

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuth =
          await googleSignInAccount.authentication;
      if (googleSignInAuth.accessToken != null &&
          googleSignInAuth.idToken != null) {
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleSignInAuth.accessToken,
          idToken: googleSignInAuth.idToken,
        );
        final AuthResult authResult =
            await _auth.signInWithCredential(credential);
        final FirebaseUser user = authResult.user;
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);

        _setDataUser(user);
        return user;
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  // Login with email
  Future<FirebaseUser> handleSignIn(
    email,
    password,
    GlobalKey<ScaffoldState> scaffoldKey,
  ) async {
    AuthResult firebaseAuth;
    try {
      firebaseAuth = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (err) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err.message),
        duration: Duration(seconds: 5),
      ));
      throw (err);
    }
    _setDataUser(firebaseAuth.user);
    return firebaseAuth.user;
  }
}

Future _setDataUser(currentUser) async {
  Map metaData = {
    "createdBy": "0L1uQlYHdrdrG0D5CroAeybZsL33",
    "createdDate": DateTime.now(),
    "docId": currentUser.uid,
    "env": "production",
    "fl_id": currentUser.uid,
    "locale": "en-US",
    "schema": "users",
    "schemaRef": "fl_schemas/RIGJC2G8tsCBml0270IN",
    "schemaType": "collection",
  };
  try {
    if (currentUser.uid != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Firestore.instance
          .collection('fl_content')
          .where('_fl_meta_.fl_id', isEqualTo: currentUser.uid)
          .getDocuments()
          .then((QuerySnapshot snapshot) async {
        var expiryDate;

        // check if user exists.
        if (snapshot.documents.length > 0) {
          // check if user has any subscribed plan.
          if (snapshot.documents[0].data.containsKey('transaction') &&
              snapshot.documents[0].data['transaction'].length > 0) {
            expiryDate = DateTime.parse(snapshot
                            .documents[0].data['transaction']
                        [snapshot.documents[0].data['transaction'].length - 1]
                    ['expiryDate'])
                .toLocal();
            prefs.setBool('isTrial', false);
          } else {
            // else expiryDate = joingDate + 7 days.
            expiryDate =
                DateTime.parse(snapshot.documents[0].data['joiningDate'])
                    .add(new Duration(days: 7));
            prefs.setBool('isTrial', true);
          }
        } else {
          // else if the user does not exists, expiryDate = currentDate + 7 days.
          expiryDate = DateTime.now().add(new Duration(days: 7));
          Firestore.instance
              .collection("fl_content")
              .document(currentUser.uid)
              .setData({
            "_fl_meta_": metaData,
            "email": currentUser.email,
            "name": currentUser.displayName,
            "photoUrl": currentUser.photoUrl,
            "joiningDate": DateTime.now().toString()
          }, merge: true);
          prefs.setBool('isTrial', true);
        }
        // Set the expiryDate in shared preferences. To lock or unlock content.
        prefs.setString('expiryDate', expiryDate.toString());
      });
    }
  } catch (err) {
    print("Error: $err");
  }
}
