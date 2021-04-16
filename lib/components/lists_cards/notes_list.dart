import 'package:clinic/components/lists_cards/doctor_card_client.dart';
import 'package:clinic/components/lists_cards/note_card.dart';
import 'package:clinic/models/note.dart';
import 'package:clinic/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<List<Note>>(context) ?? [];
    final userData = Provider.of<UserModel>(context);
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return NoteCard(note: notes[index]);
      },
    );
  }
}
