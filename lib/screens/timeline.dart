import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timeline_provider.dart';

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TimelineProvider>(context, listen: false).fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final timelineProvider = Provider.of<TimelineProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Timeline'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: InputDecoration(
                      hintText: 'Write something...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final content = _postController.text;
                    if (content.isNotEmpty) {
                      timelineProvider.addPost(content);
                      _postController.clear();
                    }
                  },
                  child: Text('Post'),
                ),
              ],
            ),
          ),
          Expanded(
            child: timelineProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: timelineProvider.posts.length,
                    itemBuilder: (context, index) {
                      final post = timelineProvider.posts[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(post['content']),
                          subtitle: Text(
                              'By: ${post['author']}\nLikes: ${post['likes']}'),
                          trailing: IconButton(
                            icon: Icon(Icons.thumb_up, color: Colors.indigo),
                            onPressed: () =>
                                timelineProvider.likePost(post['id']),
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
