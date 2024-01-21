// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:csexplorer/data/model/reply.dart';
import 'package:csexplorer/data/repositories/forum_repo.dart';
import 'package:csexplorer/service/authService.dart';
import 'package:flutter/material.dart';
import 'package:csexplorer/data/model/forum.dart' as Forum;

class ForumDiscussion extends StatefulWidget {
  final Forum.Forum forum;

  const ForumDiscussion({Key? key, required this.forum}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForumDiscussionState createState() => _ForumDiscussionState();
}

class _ForumDiscussionState extends State<ForumDiscussion> {
  final ForumRepository _forumRepository = ForumRepository();
  // ignore: unused_field
  late Timer _refreshTimer;
  final int refreshIntervalInMilliseconds = 1000;
  late Future<List<String>> _replyList =
      ForumRepository.retrieveRepliesForSubject(widget.forum.subject);
  List<String> updatedList = [];
  List<int> likesCounts = [];
  List<String> replyList = [];
  List<String> likeId= [];
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
  }

  @override
  void dispose() {
    _startRefreshTimer();
    super.dispose();
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
      setState((
       
      ) {
        
      });
    }
  }

  Future<void> retrieveId() async {
    author = await ForumRepository.retrieveIdsForSubject(widget.forum.subject);
    if (mounted) {
      setState(() {
       
      });
    }
  }

  Future<void> retrieveList() async
  {
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

            // ignore: avoid_print
            print('Error fetching data: $error');
          });
        }
        catch (error) {
          // ignore: avoid_print
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

    void showReplyDialog() {
      TextEditingController replyController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // ignore: prefer_const_constructors
            title: Text('Type your reply'),
            content: TextField(
              controller: replyController,
              decoration: const InputDecoration(
                hintText: 'Type your reply here...',
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  String replyText = replyController.text;
                  String subject = widget.forum.subject;

                  String replyId = await ForumRepository.addReplyToSubject(
                      subject, replyText, name, userId,likeId);

                  replyList.add(replyId);

                  nameList.add(name);

                  Navigator.pop(context);
                },
                child: const Text('Send'),
              ),
            ],
          );
        },
      );
    }

    Future<String> showEditDialog() async {
      TextEditingController replyController = TextEditingController();
      Completer<String> completer = Completer<String>();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit your reply'),
            content: TextField(
              controller: replyController,
              decoration: const InputDecoration(
                hintText: 'Type your reply here...',
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  String replyText = replyController.text;
                  Navigator.pop(context);
                  completer.complete(replyText);
                },
                child: const Text('Edit'),
              ),
            ],
          );
        },
      );

      return completer.future;
    }

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
                          String userId = AuthService.getCurrentUserId();
                          String authorId = author[index];

                          bool isAuthor = userId == authorId;

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
                                      
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(name),
                                          
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
                                      if (isAuthor)
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () async {
                                            String updatedReply =
                                                // ignore: await_only_futures
                                                await showEditDialog();
                                            // ignore: unnecessary_null_comparison
                                            if (updatedReply != null) {
                                              await ForumRepository.editReply(
                                                  widget.forum.subject,
                                                  replyId,
                                                  updatedReply);
                                            }
                                          },
                                        ),
                                      if (isAuthor)
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () async {
                                            await ForumRepository.deleteReply(
                                                widget.forum.subject, replyId);
                                          },
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                  
                                      InkWell(
                                        onTap: () async {
                                          if (mounted) {

                                            List<String> currentLikesId =
                                                await ForumRepository
                                                    .retrieveAllLikesIdForReply(
                                                        widget.forum.subject,
                                                        replyId);

                                            if (currentLikesId
                                                .contains(userId))
                                                {
                                             
                                              await ForumRepository
                                                  .removeLikesIdForReply(
                                                      widget.forum.subject,
                                                      replyId,
                                                      userId);
                                            }
                                             else
                                             {
                                             
                                              await ForumRepository
                                                  .addLikesIdForReply(
                                                      widget.forum.subject,
                                                      replyId,
                                                      userId);
                                            }

                                            handleLikesUpdate(replyId, index);
                                          }
                                        },

                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.favorite_border_outlined),
                                            const SizedBox(width: 3),
                                            FutureBuilder<int>(
                                              future: _forumRepository
                                                  .retrieveLikesCountForReply(
                                                      widget.forum.subject,
                                                      replyId),
                                              builder:
                                                  (context, likesSnapshot) {
                                                if (likesSnapshot.hasError) {
                                                  return Text(
                                                      'Error: ${likesSnapshot.error}');
                                                } else {
                                                  int likesCount =
                                                      likesSnapshot.data ?? 0;
                                                  return Text(
                                                    'Likes $likesCount',
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
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
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 60,
            right: 10,
            child: FloatingActionButton(
              onPressed: showReplyDialog,
              tooltip: 'Reply',
              child: const Icon(Icons.comment),
            ),
          ),
        ],
      ),
    );
  }
}
