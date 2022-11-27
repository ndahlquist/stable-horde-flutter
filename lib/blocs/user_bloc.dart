import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class _UserBloc {
  bool isAdmin() {
    return getMyUserId() == 'L5xmX0dCKZVNAGOj0lXSfgsHf2r1';
  }

  Future<bool> isApprovedForBeta() async {
    final config = FirebaseRemoteConfig.instance;
    if (!config.getBool("waitlist_enabled")) {
      return true;
    }

    final userId = getMyUserId()!;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final user = await userDoc.get();
    return user.data()!['waitlist_approved'] ?? false;
  }

  String? getMyUserId() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null) {
      return null;
    }
    return user.uid;
  }

  Future setMyUsername(String username) async {
    final userId = getMyUserId()!;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    await userDoc.set({
      'username': username,
    }, SetOptions(merge: true));
  }

  Future<String?> getMyUsername() async {
    final userId = getMyUserId();
    if (userId == null) {
      return null;
    }

    return getUsernameForUserId(userId).first;
  }

  Stream<String?> getMyUsernameStream() {
    final userId = getMyUserId()!;

    return getUsernameForUserId(userId);
  }

  Stream<String?> getUsernameForUserId(String userId) {
    assert(userId.isNotEmpty);

    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    return userDoc.snapshots().map((doc) => doc.data()?['username']);
  }

  Future<bool> setupPushNotifications() async {
    await FirebaseMessaging.instance.requestPermission(
      badge: false,
      sound: false,
    );

    return refreshFcmToken();
  }

  Future<bool> refreshFcmToken() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    final authStatus = settings.authorizationStatus;
    if (authStatus == AuthorizationStatus.notDetermined ||
        authStatus == AuthorizationStatus.denied) {
      return false;
    }

    final userId = getMyUserId();
    if (userId == null) return false;

    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) return false;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    userDoc.set({
      'fcm_token': fcmToken,
    }, SetOptions(merge: true));

    return true;
  }
}

final userBloc = _UserBloc();
