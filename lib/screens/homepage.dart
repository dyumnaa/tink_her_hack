import 'package:flutter/material.dart';
import 'timeline.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true, // Center the AppBar title
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.yellow), // Changed color to yellow
            onPressed: () {
              // Navigate to profile
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.timeline, color: Colors.white),
          onPressed: () {
            // Navigate to timeline
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TimelinePage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimelinePage()),
                );
              },
              icon: Icon(Icons.timeline),
              label: Text('Timeline'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search friends...',
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
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade200,
                        child: Text(
                          'A',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text('Friend ${index + 1}'),
                      subtitle: Text('Last message preview...'),
                      trailing: Icon(Icons.message, color: Colors.indigo),
                      onTap: () {
                        // Navigate to chat
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
