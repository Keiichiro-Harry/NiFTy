import 'package:flutter/material.dart';
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
// import './add_book_page.dart';
// import './add_post_page.dart';
// import './assignments.dart';
// import './bookcards.dart';
// import './bookshelf.dart';
import './login_page.dart';
// import './memoria_game.dart';
import './notification.dart';
// import './recommendation.dart';
// import './screen_transition.dart';
// import './setting.dart';
import 'account.dart';
import 'bookmark.dart';
import 'home.dart';
import 'notification.dart';
import 'main.dart';

class NiFTy extends StatelessWidget {
  const NiFTy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NiFTy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class ScreenTransition extends StatefulWidget {
  late final List<Widget> _screens;
  final User user;
  ScreenTransition(this.user, {Key? key}) : super(key: key) {
    _screens = [
      HomeScreen(user),
      BookmarkScreen(),
      NotificationScreen(),
      AccountScreen()
    ];
  }

  @override
  State<ScreenTransition> createState() => _ScreenTransitionState();
}

class _ScreenTransitionState extends State<ScreenTransition> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var state = Get.put(Controller());
  String barName = "ホーム";
  List<String> namesList = ['ホーム', 'お気に入り', 'お知らせ', 'アカウント'];
  void changeName(name) => setState(() => barName = name);
  final views = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: Text(barName), actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                // ログイン画面に遷移＋チャット画面を破棄
                await FirebaseAuth.instance.signOut();
                // ログイン画面に遷移＋チャット画面を破棄
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }),
                );
              },
            ),
          ]),
          //(3) ページ切替機構
          body: widget._screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (int i) {
              _onItemTapped(i);
              state.selected.value = i;
              changeName(namesList[i]);
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: namesList[0],
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: namesList[1]),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications), label: namesList[2]),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: namesList[3]),
            ],
            type: BottomNavigationBarType.fixed,
          ),
        ));
  }
}
