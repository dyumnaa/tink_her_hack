import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Mock data for users
  final List<Map<String, dynamic>> users = [
    {
      'name': 'Alice',
      'isInNetwork': false,
      'details': 'Software Engineer at TechCorp'
    },
    {
      'name': 'Bob',
      'isInNetwork': true,
      'details': 'Graphic Designer at Artify'
    },
    {
      'name': 'Charlie',
      'isInNetwork': false,
      'details': 'Freelance Photographer'
    },
  ];

  List<Map<String, dynamic>> searchResults = [];
  Map<String, dynamic>? selectedUser;

  void _searchUser(String query) {
    setState(() {
      searchResults = users
          .where((user) =>
              user['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
      selectedUser = null; // Reset selected user on new search
    });
  }

  void _viewProfile(Map<String, dynamic> user) {
    setState(() {
      selectedUser = user;
    });
  }

  void _kinnect(Map<String, dynamic> user) {
    setState(() {
      user['isInNetwork'] = true; // Update their network status
      selectedUser = user; // Refresh the profile view
    });
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
                          trailing: Icon(Icons.person, color: Colors.indigo),
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
          ),
      ],
    );
  }
}
