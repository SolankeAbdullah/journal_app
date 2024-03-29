import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:jornal_app/classes/journal.dart';
import 'package:jornal_app/classes/journal_edit.dart';

class EditEntry extends StatefulWidget {
  const EditEntry(
      {super.key,
      required this.add,
      required this.index,
      required this.journalEdit});
  final bool add;
  final int index;
  final JournalEdit journalEdit;

  @override
  State<EditEntry> createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  JournalEdit? _journalEdit;
  Journal? journal;
  String _title = '';
  DateTime? _selectedDate;
  final TextEditingController _moodController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _moodFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();
  @override
  void initState() {
    super.initState();

    _journalEdit =
        JournalEdit(action: "Cancel", journal: widget.journalEdit.journal);

    _title = widget.add ? 'Add' : 'Edit';

    if (widget.add) {
      _selectedDate = DateTime.now();
      _moodController.text = "";
      _noteController.text = "";
    } else {
      _selectedDate = DateTime.parse(_journalEdit!.journal.date);
      _moodController.text = _journalEdit!.journal.mood;
      _noteController.text = _journalEdit!.journal.note;
    }
  }

  @override
  void dispose() {
    _moodController.dispose();
    _noteController.dispose();
    _moodFocus.dispose();
    _noteFocus.dispose();

    super.dispose();
  }

  Future<DateTime> _selectDate(DateTime selectedDate) async {
    DateTime initialDate = selectedDate;
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now().add(const Duration(days: 365)));

    if (pickedDate != null) {
      selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          initialDate.hour,
          initialDate.minute,
          initialDate.second,
         initialDate.millisecond,
          initialDate.microsecond);
    }
    return selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Entry"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.black54,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    DateFormat.yMMMEd().format(_selectedDate!),
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black54,
                  )
                ],
              ),
              onPressed: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime _pickerDate = await _selectDate(_selectedDate!);
                setState(() {
                  _selectedDate = _pickerDate;
                });
              },
            ),
            TextField(
              controller: _moodController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              focusNode: _moodFocus,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Mood',
                icon: Icon(Icons.mood),
              ),
              onSubmitted: (submitted) {
                FocusScope.of(context).requestFocus(_noteFocus);
              },
            ),
            TextField(
              controller: _noteController,
              textInputAction: TextInputAction.newline,
              focusNode: _noteFocus,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Note',
                icon: Icon(Icons.subject),
              ),
              maxLines: null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    _journalEdit!.action = 'Cancel';
                    Navigator.pop(context, _journalEdit);
                  },
                ),
                SizedBox(width: 8.0),
                TextButton(
                  onPressed: () {
                    _journalEdit!.action = "Save";
                    String _id = widget.add
                        ? Random().nextInt(9999999).toString()
                        : _journalEdit!.journal.id;
                    _journalEdit!.journal = Journal(
                        id: _id,
                        date: _selectedDate.toString(),
                        mood: _moodController.text,
                        note: _noteController.text);
                    Navigator.pop(context, _journalEdit);
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.lightGreen.shade100),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
