import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> searchResults = [];
  Map<String, dynamic>? selectedUser;

  void _searchUser(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      setState(() {
        searchResults = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'uid': doc.id,
            'name': data['name'] ?? 'Unknown',
            'details': data['bio'] ?? 'No bio available',
            'isInNetwork': false, // Default to false initially
          };
        }).toList();
      });

      // Check if users are already friends
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final friendsSnapshot = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('friends')
            .get();

        final friends = friendsSnapshot.docs.map((doc) => doc.id).toSet();

        setState(() {
          for (var user in searchResults) {
            user['isInNetwork'] = friends.contains(user['uid']);
          }
        });
      }
    } catch (e) {
      print('Error searching users: $e');
    }
  }

  void _viewProfile(Map<String, dynamic> user) {
    setState(() {
      selectedUser = user;
    });
  }

  Future<void> _kinnect(Map<String, dynamic> user) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final currentUserRef =
          _firestore.collection('users').doc(currentUser.uid);
      final friendUserRef = _firestore.collection('users').doc(user['uid']);

      // Add friend to current user's friend list
      await currentUserRef.collection('friends').doc(user['uid']).set({
        'friendName': user['name'],
        'friendUid': user['uid'],
      });

      // Add current user to the friend's friend list (optional)
      await friendUserRef.collection('friends').doc(currentUser.uid).set({
        'friendName': currentUser.displayName ?? 'Unknown',
        'friendUid': currentUser.uid,
      });

      setState(() {
        user['isInNetwork'] = true; // Update the UI
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are now friends with ${user['name']}!')),
      );
    } catch (e) {
      print('Error connecting with user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Friends'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: _searchUser,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: selectedUser == null
                  ? ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final user = searchResults[index];
                        return ListTile(
                          title: Text(user['name']),
                          subtitle: Text(user['details']),
                          trailing: Icon(
                            user['isInNetwork']
                                ? Icons.person
                                : Icons.person_add,
                            color: Colors.indigo,
                          ),
                          onTap: () => _viewProfile(user),
                        );
                      },
                    )
                  : _buildProfileView(selectedUser!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileView(Map<String, dynamic> user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user['name'],
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          user['details'],
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        if (!user['isInNetwork'])
          ElevatedButton.icon(
            onPressed: () => _kinnect(user),
            icon: Icon(Icons.person_add),
            label: Text('Kinnect'),
          )
        else
          Text(
            'You are already friends with ${user['name']}!',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}
