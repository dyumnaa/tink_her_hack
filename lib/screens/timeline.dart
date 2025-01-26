import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timeline_provider.dart';

class TimelinePage extends StatefulWidget {
  final String? friendUid; // Optional argument for friend's UID

  TimelinePage({this.friendUid}); // Constructor

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timelineProvider =
          Provider.of<TimelineProvider>(context, listen: false);
      if (widget.friendUid != null) {
        // Fetch friend's timeline if friendUid is provided
        timelineProvider.fetchPostsForUser(widget.friendUid!);
      } else {
        // Fetch current user's timeline
        timelineProvider.fetchPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final timelineProvider = Provider.of<TimelineProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.friendUid != null ? 'Friend\'s Timeline' : 'Your Timeline'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (widget.friendUid ==
              null) // Allow posting only for the current user
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Write something...',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (content) {
                        if (content.isNotEmpty) {
                          timelineProvider.addPost(content);
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Trigger the add post function
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
