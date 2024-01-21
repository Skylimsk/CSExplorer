import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:csexplorer/data/model/reply.dart';
import 'package:csexplorer/data/repositories/forum_repo.dart';
import 'package:csexplorer/service/authService.dart';
import 'package:flutter/material.dart';
import 'package:csexplorer/data/model/forum.dart' as Forum;

class ManageForumDiscussion extends StatefulWidget 
{
  final Forum.Forum forum;

  const  ManageForumDiscussion({Key? key, required this.forum}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ManageForumDiscussionState createState() => _ManageForumDiscussionState();
}

class _ManageForumDiscussionState extends State<ManageForumDiscussion> {
  final ForumRepository _forumRepository = ForumRepository();
  // ignore: unused_field
  late Timer _refreshTimer;
  final int refreshIntervalInMilliseconds = 1000;
  late Future<List<String>> _replyList =
      ForumRepository.retrieveRepliesForSubject(widget.forum.subject);
  List<String> updatedList = [];
  List<int> likesCounts = [];
  List<String> replyList = [];
  int updatedLikes = 0;
  int likesCount = 0;
  String replyID = "";
  late Future<List<String>> allReplyIds =
      ForumRepository.getAllReplyIdsForSubject(widget.forum.subject);
  String userId = AuthService.getCurrentUserId();
  String name = "";
  List<String> nameList = [];
  List<String> author = [];

  @override
  void initState() {
    super.initState();
    _startRefreshTimer();
    fetchData();
    initializeName();
    retrieveName();
    retrieveList();
    retrieveId();
    _startRefreshTimer();
  }

  Future<void> handleLikesUpdate(String replyId, int index) async {
    updatedLikes = await _forumRepository.retrieveLikesForReply(
        widget.forum.subject, replyId);

    setState(() {
      if (index >= likesCounts.length) {
        likesCounts.add(updatedLikes);
      } else {
        likesCounts[index] = updatedLikes;
      }
    });
  }

  Future<void> initializeName() async {
    name = await AuthService.getUserNameById(userId);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> retrieveName() async {
    nameList =
        await ForumRepository.retrieveNamesForSubject(widget.forum.subject);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> retrieveId() async {
    author = await ForumRepository.retrieveIdsForSubject(widget.forum.subject);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> retrieveList() async {
    updatedList =
        await ForumRepository.retrieveRepliesForSubject(widget.forum.subject);
    if (mounted) {
      setState(() {});
    }
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(
      Duration(milliseconds: refreshIntervalInMilliseconds),
      (timer) {
        try {
          fetchData();
          Future.wait([
            retrieveList(),
            retrieveName(),
            retrieveId(),
          ]).then((_) {
            fetchData();
            setState(() {
              _replyList = Future.value(updatedList);
            });
            fetchData();
          }).catchError((error) {
            // Handle errors appropriately
            print('Error fetching data: $error');
          });
        } catch (error) {
          // Handle errors appropriately
          print('Error: $error');
        }
      },
    );
  }

  void fetchData() async {
    replyList =
        await ForumRepository.getAllReplyIdsForSubject(widget.forum.subject);

    likesCounts = List<int>.filled(replyList.length, 0);

    for (int i = 0; i < replyList.length; i++) {
      await handleLikesUpdate(replyList[i], i);
    }
  }

  Widget _buildImageWidget(String imagePath) {
    // ignore: unnecessary_null_comparison
    if (imagePath == null || imagePath.isEmpty) {
      return Container();
    }

    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      return Image.network(
        imagePath,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imagePath),
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: const Text('View Post'),
      ),
      body: FutureBuilder<List<String>>(
          future: _replyList,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              List<String> replies = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        width: cardWidth,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 15,
                                  backgroundImage: AssetImage(
                                    'assets/images/defaultProfilePic.jpg',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.forum.name),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        widget.forum.subject,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 100,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        widget.forum.message,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 100,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // ignore: unnecessary_null_comparison
                                    if (widget.forum.image != null)
                                      _buildImageWidget(widget.forum.image)
                                    else
                                      Container(),
                                  ],
                                ),
                                const Spacer(),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'Discussion ${updatedList.length}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: min(replyList.length, replies.length),
                      itemBuilder: (context, index) {
                        if (index < nameList.length &&
                            index < replyList.length &&
                            index < replies.length &&
                            index < author.length) {
                          String name = nameList[index];
                          String comment = replies[index];
                          String replyId = replyList[index];
                          String authorId = author[index];

                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Container(
                              width: cardWidth,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CircleAvatar(
                                        radius: 15,
                                        backgroundImage: AssetImage(
                                          'assets/images/defaultProfilePic.jpg',
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(name),
                                          //Text("name,$author"),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              comment,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 100,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      
                                      
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () async {
                                            await ForumRepository.deleteReply(
                                                widget.forum.subject, replyId);
                                            ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Reply deleted. Notification sent to email.'),
                                            ),
                                          );
                                          },
                                        ),
                                    ],
                                  ),
                                  
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
      
    );
  }
}
