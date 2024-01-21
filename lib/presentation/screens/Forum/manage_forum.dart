import 'package:csexplorer/presentation/screens/Forum/manage_forum_topic.dart';
import 'package:flutter/material.dart';

class ManageForum extends StatefulWidget {
  const ManageForum({super.key});

  @override
  State<ManageForum> createState() => _ManageForumMainState();
}

class _ManageForumMainState extends State<ManageForum> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forum')),
      body: const ManageForumTopic(),
    );
  }
}
