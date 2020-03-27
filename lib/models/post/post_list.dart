import 'package:boilerplate/models/post/post.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'post_list.g.dart';

@CopyWith()
class PostList {
  final List<Post> posts;

  PostList({
    this.posts,
  });

  factory PostList.fromJson(List<dynamic> json) {
    List<Post> posts = List<Post>();
    posts = json.map((post) => Post.fromMap(post)).toList();

    return PostList(
      posts: posts,
    );
  }
}
