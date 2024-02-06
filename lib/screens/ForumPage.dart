import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final TextEditingController commentController = TextEditingController();
  String selectedSection = 'Películas del Momento';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foro de Películas'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.blue, // Cambia el color de fondo según tu preferencia
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButton(
              value: selectedSection,
              onChanged: (String? value) {
                setState(() {
                  selectedSection = value!;
                });
              },
              items: ['Películas del Momento', 'Películas Famosas', 'Películas que Odio']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.white), // Cambia el color del texto según tu preferencia
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: CommentList(selectedSection),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu comentario...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    addComment(selectedSection);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('exit'),
        ),
      );
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  void addComment(String section) async {
    if (commentController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection(section).add({
        'text': commentController.text,
        'userEmail': FirebaseAuth.instance.currentUser?.email ?? 'Usuario Anónimo',
      });

      commentController.clear();
    }
  }
}

class Comment {
  final String text;
  final String userEmail;

  Comment({required this.text, required this.userEmail});

  Comment.fromSnapshot(DocumentSnapshot snapshot)
      : text = snapshot['text'],
        userEmail = snapshot['userEmail'];
}

class CommentList extends StatelessWidget {
  final String selectedSection;

  CommentList(this.selectedSection);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(selectedSection).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error al cargar comentarios: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No hay comentarios.'));
        }

        var comments = snapshot.data!.docs.map((doc) => Comment.fromSnapshot(doc)).toList();

        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(comments[index].text),
              subtitle: Text(comments[index].userEmail),
            );
          },
        );
      },
    );
  }
}
