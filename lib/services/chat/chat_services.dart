import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatServices extends ChangeNotifier {
  // get instance of firestore & auth

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // get user stream

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go thorugh each individual color
        final user = doc.data();

        // return user
        return user;
      }).toList();
    });
  }

  // get all users exept blocked users
  Stream<List<Map<String, dynamic>>> getUsersStreamExceptBlocked() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      // Get list of blocked user IDs
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      // Get all users
      final usersSnapshot = await _firestore.collection('Users').get();

      // Filter out current user and blocked users, return as a list of maps
      return usersSnapshot.docs
          .where((doc) =>
              doc.id != currentUser.uid && !blockedUserIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

  // send message

  Future<void> sendMessage(String receiverID, message) async {
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create anew message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    // construct a chat room for two users(sorted to ensure uniqueness)
    List<String> users = [currentUserID, receiverID];
    users
        .sort(); // sort the ids (this ensure the chatroom Id is the same for both users)
    String chatRoomID = users.join("_");

    // add a new message to database

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct a chat room for two users(sorted to ensure uniqueness)
    List<String> users = [userID, otherUserID];
    users
        .sort(); // sort the ids (this ensure the chatroom Id is the same for both users)
    String chatRoomID = users.join("_");

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // Report User
  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser;
    final report = {
      "reportedBy": currentUser!.uid,
      "reportedUser": userId,
      "messageId": messageId,
      "timestamp": Timestamp.now()
    };

    await _firestore.collection('Reports').add(report);
  }

  // Block user

  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userId)
        .set({});

    notifyListeners();
  }

  // Unblock user

  Future<void> unblockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userId)
        .delete();

    notifyListeners();
  }

  // Get blocked users stream

  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      // get list of blocked users
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(blockedUserIds
          .map((userId) => _firestore.collection('Users').doc(userId).get()));

      // return as a list
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
