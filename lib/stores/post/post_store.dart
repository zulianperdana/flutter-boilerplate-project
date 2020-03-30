import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'post_store.g.dart';

class PostStore = _PostStore with _$PostStore;

abstract class _PostStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _PostStore(Repository repository) : _repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<PostList> emptyPostResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<PostList> fetchPostsFuture =
      ObservableFuture<PostList>(emptyPostResponse);

  @observable
  PostList postList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchPostsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getPosts() async {
    final future = _repository.postRepository.loadPosts();
    fetchPostsFuture = ObservableFuture(future);

    future.then((postList) {
      postList = postList;
    }).catchError((error) {
      print(error);
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  void initStore(){
    final PostDataSource postDataSource = _repository.postRepository.postDataSource;
    postList = PostList(posts:postDataSource.posts);
  }

  void saveStore(){
    _repository.postRepository.savePostDataSource(posts: postList.posts);
  }

  @action
  void deleteFirstEntry(){
    postList = postList.copyWith(posts: postList.posts.where((e) => e.id != postList.posts.first.id).toList());
    saveStore();
  }

  Future<String> testSecureStorage(){
    return Future.value('');
  }
}
