import 'package:flutter/material.dart';
import 'package:untitled/db/db_helper.dart';
import 'package:untitled/models/note.dart';
import 'package:untitled/utils/date_trime_manager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => MyHomePage_State();
}

class MyHomePage_State extends State<MyHomePage> {
  TextEditingController? _noteController;
  GlobalKey<FormState>? _formKey;
  List<Note> _notes = [];
  @override
  void initState() {
    _noteController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('NoteSaver'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _noteController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          filled: true,
                          fillColor: Colors.lightGreen,
                          hintText: 'write note'),
                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          value!.isEmpty ? 'note required' : null,
                    ),
                  SizedBox(height: 8,),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey!.currentState!.validate()) {
                            String note = _noteController!.value.text;
                            Note noteObj = Note(
                                note: note, date: DateTimeManager.getDate());
                            saveNote(noteObj);
                          }
                        },
                        child: Text('Add Note'))
                  ],
                ),
              ),
            ),
            ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                      leading: Icon(Icons.note),
                      title: Text(_notes[index].note!),
                      subtitle: Text(_notes[index].date!),
                      trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    editNote(_notes[index]);
                                  },
                                  icon: Icon(Icons.edit)),
                              SizedBox(
                                width: 3,
                              ),
                              IconButton(
                                  onPressed: () {
                                    deletNote(_notes[index].noteId);
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          )),
                    ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: _notes.length)
          ],
        ),
      ),
    );
  }

  void saveNote(Note note) {
    DBHelper.dbHelper.saveNote(note).then((value) => this.setState(() {
          print('1 row added');
          _noteController!.clear();
          getNotes();
        }));
  }

  void getNotes() {
    print('nnnnn *********************************************** ');
    DBHelper.dbHelper.geNotes().then((value) => this.setState(() {
          _notes = value;
        }));
  }

  void deletNote(int? noteId) {
    DBHelper.dbHelper.deleteNote(noteId).then((value) {
      this.setState(() {
        getNotes();
      });
    });
  }

  void editNote(Note editedNote) {
    TextEditingController? _editedNoteController =
        TextEditingController(text: editedNote.note);
    GlobalKey<FormState> _editFormKey = GlobalKey();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('UPDATE NOTE'),
              content: Form(
                key: _editFormKey,
                child: TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Note cant be empty' : null,
                  controller: _editedNoteController,
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (_editFormKey.currentState!.validate()) {
                        String newNote = _editedNoteController.value.text;
                        editedNote.note = newNote;
                        updateNote(editedNote);
                      }
                    },
                    child: Text('Update')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
              ],
            ));
  }

  void updateNote(Note note) {
    DBHelper.dbHelper.updateNote(note).then((value) {
      print('note updated');
      this.setState(() {
        getNotes();
        Navigator.pop(context);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _noteController!.dispose();
    super.dispose();
  }
}
