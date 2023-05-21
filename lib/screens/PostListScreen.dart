// ignore_for_file: use_key_in_widget_constructors, implementation_imports, unnecessary_this

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:simpleworld/screens/components/multi_manager/flick_multi_manager.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'components/web_video_player/web_video_player.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class PostListScreen extends StatefulWidget {
  static String tag = '/PostsScreen';

  // ignore: non_constant_identifier_names
  const PostListScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final String? currentUserId;

  bool isGlobal = false;
  bool isLoading = false;
  late FlickMultiManager flickMultiManager;

  var reportPostData;

  _PostListScreenState({
    this.currentUserId,
  });

  @override
  void initState() {
    super.initState();
    flickMultiManager = FlickMultiManager();
    flickMultiManager.pause();
  }

  @override
  void dispose() {
    flickMultiManager = FlickMultiManager();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsRef = FirebaseFirestore.instance.collection('posts');
    productsRef.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        print(doc.data);
      });
    });
    return Scaffold(
      appBar: appBarWidget('Posts', showBack: false, elevation: 0.0),
      body: followersPostList(),
    );
  }

  Widget buildItem(List messenger, int index) {
    bool isPdf = messenger[index]['type'] == 'pdf';
    bool isVide = messenger[index]['type'] == 'video';
    bool isPhoto = messenger[index]['type'] == 'photo';
    bool isText = messenger[index]['type'] == 'text';
    if (isPhoto) {
      return Container(
        width: 200,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(8),
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                blurRadius: 5, spreadRadius: 1, color: gray.withOpacity(0.2)),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  messenger[index]['mediaUrl'][0],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRect(16),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(bottom: 10, left: 10),
                  child: Text(
                    messenger[index]['description']!,
                    style: GoogleFonts.roboto(),
                  ),
                ),
                16.height,
                Text(messenger[index]['username'], style: boldTextStyle()),
              ],
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  handleDeletePosts(context, messenger, index);
                },
              ),
            ),
          ],
        ),
      );
    } else if (isVide) {
      return Container(
        width: 200,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(8),
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VisibilityDetector(
                  key: ObjectKey(flickMultiManager),
                  onVisibilityChanged: (visibility) {
                    if (visibility.visibleFraction == 0 && this.mounted) {
                      flickMultiManager.pause();
                    }
                  },
                  child: SizedBox(
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: WebVideoPlayer(
                        url: messenger[index]['videoUrl']!,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(bottom: 10, left: 10),
                  child: Text(
                    messenger[index]['description']!,
                    style: GoogleFonts.roboto(),
                  ),
                ),
                16.height,
                Text(messenger[index]['username'], style: boldTextStyle()),
              ],
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  handleDeletePosts(context, messenger, index);
                },
              ),
            ),
          ],
        ),
      );
    } else if (isPdf) {
      return Container(
        width: 200,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(8),
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                blurRadius: 5, spreadRadius: 1, color: gray.withOpacity(0.2)),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(bottom: 10, left: 10),
                  child: Text(
                    messenger[index]['description']!,
                    style: GoogleFonts.roboto(),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.1,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.grey)),
                  child: ListTile(
                    title: Text(
                      messenger[index]['pdfName']!,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontSize: 16),
                    ),
                    subtitle: Text(
                      messenger[index]['pdfsize']!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                16.height,
                Text(messenger[index]['username'], style: boldTextStyle()),
              ],
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  handleDeletePosts(context, messenger, index);
                },
              ),
            ),
          ],
        ),
      );
    } else if (isText) {
      return Container(
        width: 200,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(8),
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                blurRadius: 5, spreadRadius: 1, color: gray.withOpacity(0.2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(bottom: 10, left: 10),
                  child: Text(
                    messenger[index]['description'],
                    style: GoogleFonts.roboto(),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      handleDeletePosts(context, messenger, index);
                    },
                  ),
                ),
              ],
            ),
            16.height,
            Text(messenger[index]['username'], style: boldTextStyle()),
          ],
        ),
      );
    }
    return Container();
  }

  Widget followersPostList() {
    PaginateRefreshedChangeListener refreshChangeListener =
        PaginateRefreshedChangeListener();
    return RefreshIndicator(
      child: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collectionGroup('userPosts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final isWebMobile = kIsWeb &&
                (defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.android);

            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: snapshot.data!.docs.length > 0
                  ? GridView.builder(
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, int index) {
                        List messenger = snapshot.data!.docs;
                        return buildItem(messenger, index);
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWebMobile ? 3 : 5,
                      ),
                    )
                  : const Center(
                      child: Text("Currently you don't have any messages"),
                    ),
            );
          }
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: const <Widget>[
                  CupertinoActivityIndicator(),
                ]),
          );
        },
      ),
      onRefresh: () async {
        refreshChangeListener.refreshed = true;
      },
    );
  }

  void deleteNestedSubcollections(List messenger, int index) {
    Future<QuerySnapshot> photos = FirebaseFirestore.instance
        .collection('posts')
        .doc(messenger[index]['ownerId'])
        .collection("userPosts")
        .doc(messenger[index]['postId'])
        .collection("albumposts")
        .get();
    photos.then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(messenger[index]['ownerId'])
            .collection("userPosts")
            .doc(messenger[index]['postId'])
            .collection("albumposts")
            .doc(element.id)
            .delete()
            .then((value) => print("success"));
      });
      FirebaseStorage.instance
          .refFromURL(messenger[index]['mediaUrl']!)
          .delete();
    });
  }

  deletePost(List messenger, int index) async {
    bool isPdf = messenger[index]['type'] == 'pdf';
    bool isVide = messenger[index]['type'] == 'video';
    bool isPhoto = messenger[index]['type'] == 'photo';
    FirebaseFirestore.instance
        .collection('posts')
        .doc(messenger[index]['ownerId'])
        .collection('userPosts')
        .doc(messenger[index]['postId'])
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    deleteNestedSubcollections(messenger, index);
    if (isPdf) {
      FirebaseStorage.instance.refFromURL(messenger[index]['pdfUrl']!).delete();
    } else if (isVide) {
      FirebaseStorage.instance
          .refFromURL(messenger[index]['videoUrl']!)
          .delete();
    } else {
      FirebaseStorage.instance
          .refFromURL(messenger[index]['mediaUrl']!)
          .delete();
    }

    QuerySnapshot activityFeedSnapshot = await FirebaseFirestore.instance
        .collection('feed')
        .doc(messenger[index]['ownerId'])
        .collection("feedItems")
        .where('postId', isEqualTo: messenger[index]['postId'])
        .get();
    activityFeedSnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    QuerySnapshot commentsSnapshot = await FirebaseFirestore.instance
        .collection('comments')
        .doc(messenger[index]['postId'])
        .collection('comments')
        .get();
    commentsSnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleDeletePosts(BuildContext parentConext, List messenger, int index) {
    return showDialog(
        context: parentConext,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Remove this Post?"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  deletePost(messenger, index);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }
}
