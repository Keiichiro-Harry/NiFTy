import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqflite/sqflite.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import './account.dart';
import './login_page.dart';
import './notification.dart';
import './screen_transition.dart';
import './setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// class Setting extends StatelessWidget {
//   Setting(this.user);
//   final User user;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Column(children: <Widget>[
//         const SizedBox(height: 200),

//         const SizedBox(height: 8),
//         Container(
//           width: 100,
//           height: 30,
//           child: ElevatedButton.icon(
//             onPressed: () async {
//               // 1つ前の画面に戻る
//               Navigator.of(context).pop();
//             },
//             icon: Icon(Icons.thumb_up),
//             style: ElevatedButton.styleFrom(
//               primary: Colors.red,
//               elevation: 5,
//             ),
//             label: Text('戻る'),
//           ),
//         ),
//       ]),
//     ));
//   }
// }

class Setting extends StatefulWidget {
  // Setting({Key? key}) : super(key: key);
  Setting(this.user);
  // ユーザー情報
  final User user;
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アカウントの削除'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 0,
            ),
            ElevatedButton(
                onPressed: () async {
                  final String? selectedText = await showDialog<String>(
                      context: context,
                      builder: (_) {
                        return SimpleDialogSample(widget.user);
                      });
                  // print('ユーザーを削除しました!');
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('ユーザーを削除')),
            Container(
              width: 100,
              height: 30,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // 1つ前の画面に戻る
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.thumb_up),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  elevation: 5,
                ),
                label: Text('戻る'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleDialogSample extends StatefulWidget {
  // SimpleDialogSample({Key? key}) : super(key: key);
  SimpleDialogSample(this.user);
  // ユーザー情報
  final User user;
  @override
  State<SimpleDialogSample> createState() => _SimpleDialogSampleState();
}

class _SimpleDialogSampleState extends State<SimpleDialogSample> {
  void deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final msg =
        await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('messages')
        .doc(uid)
        .delete();
    // ユーザーを削除
    await user?.delete();
    await FirebaseAuth.instance.signOut();
    print('ユーザーを削除しました!');
  }

  Future<void> goToTop(BuildContext context) async {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('退会してもよろしいですか?'),
      children: [
        SimpleDialogOption(
          child: Text('退会する'),
          onPressed: () async {
            deleteUser();
            print('ユーザーを削除しました!');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
        SimpleDialogOption(
          child: Text('退会しない'),
          onPressed: () async {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => Account(widget.user)));
            await goToTop(context);
            // print('キャンセルされました!');
          },
        )
      ],
    );
  }
}
