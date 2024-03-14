import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tipx/models/post_card_type.dart';
import 'package:tipx/ui/home/card.dart' as PostCard;
import 'package:tipx/ui/home/post.dart';

void main() {
  runApp(GlobalData(
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIPX',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber.shade800),
        // 背景顏色 #f8fafc,
        scaffoldBackgroundColor: const Color(0xfff8fafc),
        useMaterial3: true,
        // 設定預設文字大小
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      // home: const MyHomePage(title: '學校公告'),
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(title: '學校公告'),
        // "/post": (context) => const Post(""),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _pageSize = 10;

  final PagingController<int, PostCardType> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    // TODO: implement initState
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  // https://tipx.sao-x.com/api/post?type=all&id=0&limit=10

  Future<void> _fetchPage(int pageKey) async {
    try {
      developer.log('fetch page: $pageKey');
      final response = await Dio().get(
          'https://tipx.sao-x.com/api/post?type=all&id=$pageKey&limit=$_pageSize');
      // developer.log('response: ${response.data}');
      final List<PostCardType> posts = (response.data as List)
          .map((dynamic data) =>
              PostCardType.fromJson(data as Map<String, dynamic>))
          .toList();
      // developer.log('posts: $posts');
      final isLastPage = posts.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(posts);
      } else {
        final nextPageKey = pageKey + posts.length;
        _pagingController.appendPage(posts, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: PagedListView<int, PostCardType>.separated(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<PostCardType>(
                itemBuilder: (context, item, index) =>
                    PostCard.Card(post: item),
              ),
              separatorBuilder: (context, index) => const Divider()),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            //  首頁 課表 課程 個人
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: '課表'),
            BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined), label: '課程'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '個人'),
          ],
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ));
  }
}

// ignore: must_be_immutable
class GlobalData extends InheritedModel<GlobalData> {
  String? post_id;

  GlobalData({super.key, required super.child});

  static GlobalData? of(BuildContext context, {String? aspect}) =>
      InheritedModel.inheritFrom<GlobalData>(context, aspect: aspect);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
    // throw UnimplementedError();
  }

  @override
  bool updateShouldNotifyDependent(
      covariant GlobalData oldWidget, Set dependencies) {
    // TODO: implement updateShouldNotifyDependent

    if (dependencies.contains("post_id") && oldWidget.post_id != post_id) {
      return true;
    }

    return false;
    // throw UnimplementedError();
  }
}
