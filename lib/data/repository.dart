library repository;
import 'dart:async';

import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'network/apis/posts/post_api.dart';

part 'repositories/post_repository.dart';

class Repository {

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  final FlutterSecureStorage _secureStorage;

  final PostRepository postRepository;
  

  // constructor
  Repository(PostApi _postApi, this._sharedPrefsHelper, PostDataSource _postDataSource, this._secureStorage) : 
  postRepository = PostRepository(_postApi, _postDataSource);

  // Theme: --------------------------------------------------------------------
  Future<void> changeBrightnessToDark(bool value) =>
      _sharedPrefsHelper.changeBrightnessToDark(value);
  
  Future<String> testSecureStorage () async{
    return _secureStorage.read(key: 'test');
  }
    

  Future<bool> get isDarkMode => _sharedPrefsHelper.isDarkMode;

  // Language: -----------------------------------------------------------------
  Future<void> changeLanguage(String value) =>
      _sharedPrefsHelper.changeLanguage(value);

  Future<String> get currentLanguage => _sharedPrefsHelper.currentLanguage;
}
