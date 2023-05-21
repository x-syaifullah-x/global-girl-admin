import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:simpleworld/main.dart';
import 'package:simpleworld/models/UserModel.dart';
import 'package:simpleworld/utils/Colors.dart';
import 'package:simpleworld/utils/Constants.dart';

class AdminStatisticsWidget extends StatefulWidget {
  static String tag = '/AdminStatisticsWidget';

  @override
  _AdminStatisticsWidgetState createState() => _AdminStatisticsWidgetState();
}

class _AdminStatisticsWidgetState extends State<AdminStatisticsWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget itemWidget(Color bgColor, Color textColor, String title, String desc,
        IconData icon,
        {Function? onTap}) {
      return Container(
        width: 280,
        height: 145,
        decoration: BoxDecoration(
          border: Border.all(color: context.dividerColor),
          borderRadius: radius(8),
          color: bgColor,
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 30)),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(desc, style: primaryTextStyle(size: 24, color: textColor)),
                Icon(icon, color: textColor, size: 30),
              ],
            ),
          ],
        ),
      ).onTap(onTap, borderRadius: radius(16) as BorderRadius);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              StreamBuilder<List<UserModel>>(
                stream: userService.users(),
                builder: (_, snap) {
                  if (snap.hasData) {
                    return itemWidget(
                      colorPrimary,
                      white,
                      'Total Users',
                      snap.data!.length.toString(),
                      Feather.users,
                      onTap: () {
                        LiveStream().emit('selectItem', TotalUsers);
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              new StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collectionGroup('userPosts')
                    .snapshots(),
                builder: (_, snap) {
                  if (snap.hasData) {
                    return itemWidget(
                      colorPrimary,
                      white,
                      'Total Posts',
                      snap.data!.docs.length.toString(),
                      Feather.trending_up,
                      onTap: () {
                        LiveStream().emit('selectItem', TotalCategories);
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              new StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('reports')
                    .snapshots(),
                builder: (_, snapx) {
                  if (snapx.hasData) {
                    return itemWidget(
                      Colors.pink,
                      white,
                      'Reported Posts',
                      snapx.data!.docs.length.toString(),
                      Feather.unlock,
                      // onTap: () {
                      //   LiveStream().emit('selectItem', TotalCategories);
                      // },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
