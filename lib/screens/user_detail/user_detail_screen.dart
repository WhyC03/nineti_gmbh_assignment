import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nineti_gmbh_assignment/blocs/user/user_bloc.dart';
import 'package:nineti_gmbh_assignment/blocs/user/user_event.dart';
import 'package:nineti_gmbh_assignment/blocs/user/user_state.dart';
import 'package:nineti_gmbh_assignment/models/post_model.dart';
import 'package:nineti_gmbh_assignment/models/todo_model.dart';
import 'package:nineti_gmbh_assignment/models/user_model.dart';
import 'package:nineti_gmbh_assignment/screens/create_post/create_post_screen.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final List<Post> _localPosts = [];
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)!.settings.arguments as User;

    context.read<UserBloc>().add(FetchUserDetails(user.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: TextStyle(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            context.read<UserBloc>().add(const FetchUsers());
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserDetailLoaded) {
            final combinedPosts = [...state.posts, ..._localPosts];
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(user.image),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(user.email),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 125,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade300,
                      ),
                      onPressed: () async {
                        final newPost = await Navigator.push<Post>(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CreatePostScreen(
                                  onPostCreated: (post) => post,
                                ),
                          ),
                        );

                        if (newPost != null) {
                          setState(() {
                            _localPosts.add(newPost);
                          });
                        }
                      },

                      child: Row(
                        children: [
                          const Icon(Icons.add, color: Colors.black),
                          const Text(
                            "Add Post",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Posts',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  combinedPosts.isEmpty
                      ? SizedBox(
                        height: 50,
                        child: Center(child: const Text("No posts available.")),
                      )
                      : Column(
                        children:
                            combinedPosts
                                .map(
                                  (Post post) => Card(
                                    color: Colors.blue.shade50,
                                    child: ListTile(
                                      title: Text(
                                        post.title,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      subtitle: Text(
                                        post.body,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),

                  const SizedBox(height: 24),
                  const Text(
                    'Todos',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  state.todos.isEmpty
                      ? SizedBox(
                        height: 50,
                        child: Center(child: const Text("No todos available.")),
                      )
                      : Column(
                        children:
                            state.todos
                                .map(
                                  (Todo todo) => CheckboxListTile(
                                    checkColor: Colors.black45,
                                    activeColor: Colors.black45,
                                    tileColor: Colors.blue.shade50,
                                    title: Text(
                                      todo.todo,
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    value: todo.completed,
                                    onChanged: null,
                                  ),
                                )
                                .toList(),
                      ),
                ],
              ),
            );
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
