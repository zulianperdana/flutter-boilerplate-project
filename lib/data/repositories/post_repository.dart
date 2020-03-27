part of repository;

class PostRepository {
  // data source object
  final PostDataSource _postDataSource;

  final PostApi _postApi;

  PostRepository(this._postApi,this._postDataSource);
  // data source object

  Future restoreData() async{
    await _postDataSource.restore();
  }

  Future savePostDataSource({List<Post> posts})async{
    _postDataSource.posts = posts ?? _postDataSource.posts;
    _postDataSource.save();
  }

  PostDataSource get postDataSource => _postDataSource;

  // Post: ---------------------------------------------------------------------
  Future<PostList> loadPosts() {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return _postApi.getPosts().then((postsList) {
            _postDataSource.posts = postsList.posts;
            _postDataSource.save();
            return postsList;
          }).catchError((error) => throw error);
  }
}
