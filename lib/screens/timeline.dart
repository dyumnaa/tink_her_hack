import 'package:flutter/material.dart';

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  List<Map<String, dynamic>> posts = [];

  void _addPost(String type) {
    setState(() {
      posts.add({
        'type': type,
        'content': 'Sample ${type == 'Photo' ? 'Photo' : 'Video'}',
        'likes': 0,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _addPost('Photo'),
                  icon: Icon(Icons.photo),
                  label: Text('Add Photo'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _addPost('Video'),
                  icon: Icon(Icons.videocam),
                  label: Text('Add Video'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      post['type'] == 'Photo' ? Icons.photo : Icons.videocam,
                      color: Colors.indigo,
                    ),
                    title: Text(post['content']),
                    subtitle: Text('Likes: ${post['likes']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.thumb_up, color: Colors.indigo),
                      onPressed: () {
                        setState(() {
                          post['likes']++;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
