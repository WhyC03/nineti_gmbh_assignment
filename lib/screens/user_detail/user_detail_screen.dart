import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nineti_gmbh_assignment/blocs/user/user_bloc.dart';
import 'package:nineti_gmbh_assignment/blocs/user/user_event.dart';
import 'package:nineti_gmbh_assignment/blocs/user/user_state.dart';
import 'package:nineti_gmbh_assignment/models/post_model.dart';
import 'package:nineti_gmbh_assignment/models/todo_model.dart';
import 'package:nineti_gmbh_assignment/models/user_model.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

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
                  const Text(
                    'Posts',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  state.posts.isEmpty
                      ? SizedBox(
                        height: 50,
                        child: Center(child: const Text("No posts available.")),
                      )
                      : Column(
                        children:
                            state.posts
                                .map(
                                  (Post post) => Card(
                                    color: Colors.blue.shade50,
                                    child: ListTile(
                                      title: Text(post.title),
                                      subtitle: Text(post.body),
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
                                    tileColor: Colors.blue.shade50,
                                    title: Text(todo.todo),
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
