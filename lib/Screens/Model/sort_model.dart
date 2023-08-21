import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tool Rating Sorter',
      home: ToolListPage(),
    );
  }
}

class ToolListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tool Rating Sorter')),
      body: ToolList(),
    );
  }
}

class ToolList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tools').orderBy('rating', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final toolDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: toolDocs.length,
          itemBuilder: (context, index) {
            final toolData = toolDocs[index].data() as Map<String, dynamic>;
            final toolName = toolData['name'];
            final toolRating = toolData['rating'];

            return ListTile(
              title: Text(toolName),
              subtitle: Text('Rating: $toolRating'),
            );
          },
        );
      },
    );
  }
}
