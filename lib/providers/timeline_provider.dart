import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimelineProvider with ChangeNotifier {
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get posts => _posts;
  bool get isLoading => _isLoading;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Clear state
  void clear() {
    _posts = [];
    _isLoading = true;
    notifyListeners();
  }

  /// Fetch posts for the current user
  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('User not logged in');
        _isLoading = false;
        notifyListeners();
        return;
      }

      await _fetchPostsByUid(user.uid);
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch posts for a specific user by UID
  Future<void> fetchPostsForUser(String authorUid) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _fetchPostsByUid(authorUid);
    } catch (e) {
      print('Error fetching posts for user $authorUid: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Helper function to fetch posts for a given UID
  Future<void> _fetchPostsByUid(String uid) async {
    final snapshot = await _firestore
        .collection('timeline')
        .where('authorUid', isEqualTo: uid)
        .get();

    _posts = (await Future.wait(snapshot.docs.map((doc) async {
      final data = doc.data();

      // Fetch author's user document for the display name
      final userDoc =
          await _firestore.collection('users').doc(data['authorUid']).get();

      return {
        'id': doc.id,
        'content': data['content'] ?? 'No content provided',
        'likes': data['likes'] ?? 0,
        'author': userDoc.exists ? userDoc['name'] : 'Unknown User',
      };
    }).toList()))
        .where((post) => post != null)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  /// Add a post for the current user
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
        'author': userName,
      };

      final docRef = await _firestore.collection('timeline').add(newPost);

      _posts.insert(0, {
        ...newPost,
        'id': docRef.id,
      });

      notifyListeners();
    } catch (e) {
      print('Error adding post: $e');
    }
  }

  /// Like a post
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
