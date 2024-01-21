import 'dart:async';
import 'package:csexplorer/data/model/forum.dart' as Forum;
import 'package:csexplorer/data/repositories/forum_repo.dart';
import 'package:csexplorer/presentation/screens/Forum/forum_discussion.dart';
import 'package:csexplorer/service/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForumTopic extends StatefulWidget {
  const ForumTopic({super.key});

  @override
  State<ForumTopic> createState() => ForumTopicState();
}

class ForumTopicState extends State<ForumTopic> {
  final ForumRepository _forumRepository = ForumRepository();
  late Timer _refreshTimer;
  final int refreshIntervalInMilliseconds = 1000;
  late Future<List<Forum.Forum>> _forumList = _forumRepository.fetchForumList();
  List<String> updatedlist = [];
  List<String> replies = [];
  List<String> likeIds = [];
  String subject = "";
  String forum = "";
  final AuthService authService = AuthService();
  String userId = AuthService.getCurrentUserId();

  @override
  void initState() {
    super.initState();
    _startRefreshTimer();
    //retrieveId(forum);
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(
      Duration(milliseconds: refreshIntervalInMilliseconds),
      (timer) async {
        try {
          List<Forum.Forum> updatedList =
              await _forumRepository.fetchForumList();
          setState(() {
            _forumList = Future.value(updatedList);
          });
        } catch (error) {
          // ignore: avoid_print
          print('Error fetching data: $error');
        }
      },
    );
  }

  Future<List<String>> retrieveReplies(String subject) async {
    try {
      List<String> replies =
          await ForumRepository.retrieveRepliesForSubject(subject);
      return replies;
    } catch (error) {
      // ignore: avoid_print
      print('Error retrieving replies: $error');
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.9;
    return Scaffold(
      body: FutureBuilder<List<Forum.Forum>>(
        future: _forumList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No forum added"),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Forum.Forum forums = snapshot.data![index];
                String userId = AuthService.getCurrentUserId();
                bool isAuthor = userId == forums.id;
                return Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () async {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ForumDiscussion(forum: forums),
                              ),
                            );
                            replies = await retrieveReplies(forums.subject);
                          },
                          child: Container(
                            width: cardWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(forums.name),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              forums.subject,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 100,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              forums.message,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 100,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      if (isAuthor)
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Color.fromARGB(
                                                255, 251, 117, 117),
                                          ),
                                          onPressed: () async {
                                            await _forumRepository
                                                .deleteForumTopicBySubject(
                                                    forums.subject);
                                          },
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [                                     
                                      InkWell(
                                       onTap: () async {
                                          if (mounted) {

                                            likeIds =
                                                await ForumRepository
                                                    .retrieveLikesIdForForum(
                                                        forums.subject);
                                            if (likeIds
                                                .contains(userId)) {
                                            
                                              await ForumRepository
                                                  .removeLikeIdForForum(
                                                     forums.subject,
                                                      userId);
                                            } else {
                                             
                                              await ForumRepository
                                                  .addLikesIdForForum(
                                                      forums.subject,
                                                      userId);
                                            }
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.favorite_border_outlined),
                                            const SizedBox(width: 3),
                                            FutureBuilder<int>(
                                              future: _forumRepository
                                                  .retrieveLikesCountForForum(
                                                      forums.subject),
                                              builder:
                                                  (context, likesSnapshot) {
                                                if (likesSnapshot.hasError) {
                                                  return Text(
                                                      'Error: ${likesSnapshot.error}');
                                                } else {
                                                  int likesCount =
                                                      likesSnapshot.data ?? 0;
                                                  return Text(
                                                      'Likes $likesCount');
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 40),
                                      FutureBuilder<List<String>>(
                                        future: ForumRepository
                                            .retrieveRepliesForSubject(
                                                forums.subject),
                                        builder: (context, repliesSnapshot) {
                                          int repliesLength =
                                              repliesSnapshot.data?.length ?? 0;
                                          return Row(
                                            children: [
                                              const Icon(
                                                  Icons.comment_outlined),
                                              const SizedBox(width: 5),
                                              Text('Discussion $repliesLength'),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}



