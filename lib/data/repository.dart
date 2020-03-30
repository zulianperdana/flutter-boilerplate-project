library repository;
import 'dart:async';

import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/data/token/token_helper.dart';
import 'network/apis/posts/post_api.dart';

part 'repositories/post_repository.dart';
part 'repositories/auth_repository.dart';

class Repository {

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  final PostRepository postRepository;

  final AuthRepository authRepository;

  

  // constructor
  Repository(PostApi _postApi, this._sharedPrefsHelper, PostDataSource _postDataSource, TokenHelper _tokenHelper) :
  authRepository = AuthRepository(_tokenHelper), 
  postRepository = PostRepository(_postApi, _postDataSource);

  // Theme: --------------------------------------------------------------------
  Future<void> changeBrightnessToDark(bool value) =>
      _sharedPrefsHelper.changeBrightnessToDark(value);  

  Future<bool> get isDarkMode => _sharedPrefsHelper.isDarkMode;

  // Language: -----------------------------------------------------------------
  Future<void> changeLanguage(String value) =>
      _sharedPrefsHelper.changeLanguage(value);

  Future<String> get currentLanguage => _sharedPrefsHelper.currentLanguage;
}
