import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimelineProvider with ChangeNotifier {
  List<Map<String, dynamic>> _posts = []; // Holds posts fetched from Firestore
  bool _isLoading = true; // Tracks the loading state

  List<Map<String, dynamic>> get posts => _posts;
  bool get isLoading => _isLoading;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _auth.currentUser; // Get the current logged-in user
      if (user == null) {
        print('User not logged in');
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Query posts where the authorUid matches the current user's UID
      final snapshot = await _firestore
          .collection('timeline')
          .where('authorUid', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      _posts = (await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data() ?? {}; // Safely get the data as a map

        // Fetch author's user document for display name
        final userDoc =
            await _firestore.collection('users').doc(data['authorUid']).get();

        return {
          'id': doc.id,
          'content': data['content'] ?? 'No content provided',
          'likes': data['likes'] ?? 0,
          'author': userDoc.exists ? userDoc['name'] : 'Unknown User',
          'createdAt':
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        };
      }).toList()))
          .where((post) => post != null)
          .cast<Map<String, dynamic>>()
          .toList();
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPost(String content) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userName = userDoc.exists ? userDoc['name'] : user.email;

      final newPost = {
        'content': content,
        'likes': 0,
        'authorUid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore.collection('timeline').add(newPost);

      _posts.insert(0, {
        ...newPost,
        'id': docRef.id,
        'author': userName,
        'createdAt': DateTime.now(),
      });

      notifyListeners();
    } catch (e) {
      print('Error adding post: $e');
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final postIndex = _posts.indexWhere((post) => post['id'] == postId);

      if (postIndex != -1) {
        final post = _posts[postIndex];
        final updatedLikes = post['likes'] + 1;

        await _firestore.collection('timeline').doc(postId).update({
          'likes': updatedLikes,
        });

        _posts[postIndex]['likes'] = updatedLikes;
        notifyListeners();
      }
    } catch (e) {
      print('Error liking post: $e');
    }
  }
}
