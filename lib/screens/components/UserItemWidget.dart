import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:simpleworld/models/UserModel.dart';
import 'package:simpleworld/screens/AdminDashboardScreen.dart';
import 'package:simpleworld/screens/components/AppWidgets.dart';
import 'package:simpleworld/utils/Constants.dart';
import 'package:simpleworld/utils/ModelKeys.dart';

import '../../../main.dart';

class UserItemWidget extends StatefulWidget {
  static String tag = '/UserItemWidget';
  final UserModel data;

  UserItemWidget(this.data);

  @override
  _UserItemWidgetState createState() => _UserItemWidgetState();
}

class _UserItemWidgetState extends State<UserItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> makeAdmin(bool value) async {
    if (getBoolAsync(IS_TEST_USER)) return toast(mTestUserMsg);

    widget.data.isAdmin = !widget.data.isAdmin.validate();
    setState(() {});

    await userService
        .updateDocument({UserKeys.isAdmin: value}, widget.data.id).then((res) {
      //
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          widget.data.photoUrl.validate().isNotEmpty
              ? cachedImage(
                  widget.data.photoUrl,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRect(15)
              : Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF003a54),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Image.asset(
                    'assets/defaultavatar.png',
                    width: 50,
                  ),
                ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data.username.validate(), style: boldTextStyle()),
              4.height,
              Text(widget.data.email.validate(), style: secondaryTextStyle())
                  .visible(!appStore.isTester),
            ],
          ).expand(),
          Text('Delete', style: boldTextStyle(color: Colors.red))
              .paddingAll(16)
              .onTap(() {
            showConfirmDialog(context, 'Do you want to delete this user?')
                .then((value) {
              if (value ?? false) {
                if (getBoolAsync(IS_TEST_USER)) return toast(mTestUserMsg);
                postsRef.doc(widget.data.id).get().then((doc) {
                  if (doc.exists) {
                    doc.reference.delete();
                  }
                });
                userService.removeDocument(widget.data.id).then((value) {
                  toast('Deleted');
                }).catchError((e) {
                  toast(e.toString());
                });
              }
            });
          }),
        ],
      ),
    );
  }
}
