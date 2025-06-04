import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nineti_gmbh_assignment/blocs/user/user_bloc.dart';
import 'package:nineti_gmbh_assignment/blocs/user/user_event.dart';
import '../../models/post_model.dart';

class CreatePostScreen extends StatefulWidget {
  final Function(Post) onPostCreated;

  const CreatePostScreen({super.key, required this.onPostCreated});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );
      widget.onPostCreated(post);
      Navigator.pop(context, post);
      context.read<UserBloc>().add(const FetchUsers());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            context.read<UserBloc>().add(const FetchUsers());
          },
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: const Text('Create Post', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Title required'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Body'),
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Body required'
                            : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300,
                ),
                child: const Text(
                  'Add Post',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
