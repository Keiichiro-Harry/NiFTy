import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import './account.dart';
import 'package:bordered_text/bordered_text.dart';
// import './add_book_page.dart';
// import './add_bookcards_page.dart';
// import './add_bookcards_page_quick.dart';
// import './add_post_page.dart';
// import './assignments.dart';
import 'piece_cards.dart';
// import './bookshelf.dart';
import './login_page.dart';
// import './memoria_game.dart';
import './notification.dart';
// import './recommendation.dart';
import './screen_transition.dart';
// import './setting.dart';

class PieceCards extends StatefulWidget {
  PieceCards(this.user, this.bookInfo);
  // ユーザー情報
  final User user;
  final DocumentSnapshot<Object?> bookInfo;
  @override
  State<PieceCards> createState() => _PieceCardsState();
}

class _PieceCardsState extends State<PieceCards> {
  @override
  Widget build(BuildContext context) {
    // print("OK1");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookInfo['name']),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Text('ログイン情報：${widget.user.email}'),
          ),
          Expanded(
            // FutureBuilder
            // 非同期処理の結果を元にWidgetを作れる
            child: StreamBuilder<QuerySnapshot>(
              // 投稿メッセージ一覧を取得（非同期処理）
              // 投稿日時でソート
              stream: FirebaseFirestore.instance
                  .collection('galleries')
                  .doc(widget.bookInfo.id)
                  .collection(widget.bookInfo['name'])
                  //.orderBy('date')
                  //.startAt([2022,"date"])
                  //.startAt(["中枢神経", "question"])
                  .snapshots(),

              builder: (context, snapshot) {
                // データが取得できた場合
                if (snapshot.hasData) {
                  print("Check1");
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  /*
stream: FirebaseFirestore.instance
    .collection('books')
    .doc(widget.bookInfo.id)
    .collection(widget.bookInfo['name'])
    .orderBy('date')
    .snapshots(),
builder: (context, snapshot) {
  // データが取得できた場合
  if (snapshot.hasData) {
    final List<DocumentSnapshot> documents = snapshot.data!.docs;
    */
                  //final List<DocumentSnapshot> newDocuments = //indexを数字で指定するから無理だぁ〜！
                  // print("OK2");
                  // print(documents);
                  // print(documents[0]["color"]);
                  // print(documents[documents['books'].doc(widget.bookInfo.id)
                  // .collection(widget.bookInfo['name'])][0]['color']);
                  // 取得した投稿メッセージ一覧を元にリスト表示
                  return ListView.builder(
                    padding: EdgeInsets.all(18.0),
                    shrinkWrap: true,
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildImageInteractionCard(documents, index);
                    },
                  );
                }

                // データが読込中の場合
                return const Center(
                  child: Text('読込中...'),
                );
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () async {
      //     // 投稿画面に遷移
      //     await Navigator.of(context).push(
      //       MaterialPageRoute(builder: (context) {
      //         return AddBookCardsPage(widget.user, widget.bookInfo);
      //       }),
      //     );
      //   },
      // ),
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up, // childrenの先頭が下に配置されます。
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // 1つ目のFAB
          FloatingActionButton(
            // 参考※3よりユニークな名称をつけましょう。ないとエラーになります。
            // There are multiple heroes that share the same tag within a subtree.
            heroTag: "normal",
            child: Icon(Icons.add),
            // backgroundColor: Colors.blue[200],
            onPressed: () async {
              // 投稿画面に遷移
              // await Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context) {
              //     // return AddBookCardsPage(widget.user, widget.bookInfo);
              //   }),
              // );
            },
          ),
          // 2つ目のFAB
          Container(
            // 余白を設けるためContainerでラップします。
            margin: EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              // 参考※3よりユニークな名称をつけましょう。ないとエラーになります。
              heroTag: "quick",
              child: Icon(Icons.bolt),
              // backgroundColor: Colors.pink[200],
              onPressed: () async {
                // await Navigator.of(context).push(
                //   MaterialPageRoute(builder: (context) {
                //     return AddBookCardsPageQuick(widget.user, widget.bookInfo);
                //   }),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageInteractionCard(
          List<DocumentSnapshot<Object?>> documents, int index) =>
      Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Ink.image(
                  image: NetworkImage(
                    documents[index]["url"],
                  ),
                  height: 240,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  left: 16,
                  child: Text(
                    '思考カード$index',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                      fontSize: 24,
                    ),
                  ),
                  // BorderedText(
                  //   child: Text(
                  //     '思考カード$index',
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.white,
                  //       fontSize: 24,
                  //     ),
                  //   ),
                  //   strokeWidth: 2.0, //縁の太さ
                  //   strokeColor: Colors.black, //縁の色
                  // ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16).copyWith(bottom: 0),
              child: Text(
                documents[index]["aphorism"],
                style: TextStyle(fontSize: 16),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  child: Text('カードを見る'),
                  onPressed: () {},
                ),
                TextButton(
                  child: Text('作者の他の作品を見る'),
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      );
}
