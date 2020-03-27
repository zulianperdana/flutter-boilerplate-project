import 'dart:convert';

import 'package:boilerplate/data/local/datasources/base_datasource.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/utils/parser.dart';
import 'package:sembast/sembast.dart';

class PostDataSource extends BaseDataSource {
  // Constructor
  PostDataSource(Future<Database> _db) : super(_db);

  List<Post> posts = [];

  @override
  String getKey() {
    return 'post';
  }

  @override
  Map<String, dynamic> get toJson =>
      <String, dynamic>{'post': jsonEncode(posts)};

  @override
  void fromJson(Map<String, dynamic> json) {
    if (json != null) {
      posts = stringToList(json['post'], (e) => Post.fromJson(e));
    }
  }

  int count() {
    return posts.length;
  }
}
