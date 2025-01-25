import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  String? _name;
  String? _bio;

  String? get name => _name;
  String? get bio => _bio;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        _name = doc['name'];
        _bio = doc['bio'];
        notifyListeners();
      }
    }
  }

  Future<void> updateUserProfile(String name, String bio) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'bio': bio,
        'email': user.email,
      }, SetOptions(merge: true));

      _name = name;
      _bio = bio;
      notifyListeners();
    }
  }
}
