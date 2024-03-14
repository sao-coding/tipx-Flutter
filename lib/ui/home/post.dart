import 'package:flutter/material.dart';
import 'package:tipx/main.dart';
import 'package:dio/dio.dart';
import 'package:tipx/models/post_type.dart';
import 'dart:developer' as developer;
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class Post extends StatefulWidget {
  final String id;
  const Post(this.id, {super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  // https://tipx.sao-x.com/api/post?type=one&id=106066
  final Dio dio = Dio();

  Future<Response> _getPost() async {
    Response res;
    try {
      developer.log('fetch post: ${widget.id}', name: '_getPost');
      res = await dio
          .get('https://tipx.sao-x.com/api/post?type=one&id=${widget.id}');

      return res;
    } on DioException catch (e) {
      developer.log('dio error $e');
      rethrow;
    } catch (e) {
      developer.log('fetch post error $e');
      rethrow;
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   developer.log('widget.id: ${widget.id}', name: 'initState');
  //   _getPost();

  // }

  // @override
  // void dispose() {

  //   super.dispose();
  // }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getPost(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // Response res = snapshot.data;
          //  PostType post = PostType.fromJson(res.data);
          Response res = snapshot.data;
          PostType post = PostType.fromJson(res.data);
          return Scaffold(
              appBar: AppBar(
                title: Text('${post.title}'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      // do something
                      // 分享此文章
                      // https://tipx.sao-x.com/post/106079
                      Share.share(
                          '${post.title}\nhttps://tipx.sao-x.com/post/${widget.id.toString()}');
                    },
                  ),
                ],
              ),
              body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // unit category
                      Row(
                        // 樣式 between
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Text('${post.unit}'),
                            TextButton(
                              onPressed: () {
                                launchUrl(Uri(
                                  scheme: 'mailto',
                                  path: '${post.publisher?.email}',
                                  query: encodeQueryParameters(<String, String>{
                                    'subject': '關於 ${post.title}',
                                    'body': '你好，我對 ${post.title} 有興趣，想請問一些問題...'
                                  }),
                                ));
                              },
                              child: Text('${post.publisher?.name}'),
                            ),
                          ]),
                          Text('${post.category}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(Icons.event_outlined, size: 20),
                              const SizedBox(width: 4),
                              Text('${post.date}'),
                            ],
                          ),
                          Row(children: <Widget>[
                            const Icon(Icons.event_busy_outlined, size: 20),
                            const SizedBox(width: 4),
                            Text('${post.deadline}'),
                          ])
                        ],
                      ),
                      Text('${post.content}'),
                    ],
                  ),
                ),
              ));
        } else if (snapshot.hasError) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('載入失敗'),
              ),
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ));
        } else {
          return Scaffold(
              appBar: AppBar(
                title: const Text('標題載入中...'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ));
        }
      },
    );
  }
}
