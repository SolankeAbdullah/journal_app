import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jornal_app/classes/database.dart';
import 'package:jornal_app/pages/edit_entry.dart';

import 'classes/databaseroutine.dart';
import 'classes/journal.dart';
import 'classes/journal_edit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Journal Application",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DataBase? _dataBase;

  Future<List<Journal>> _loadJournals() async {
    final journalsJson = await DataBaseFileRoutine().readJournals();
    _dataBase = DataBase.fromJson(journalsJson as Map<String, dynamic>);
    _dataBase!.journal.sort((comp1, comp2) => comp2.date.compareTo(comp1.date));
    return _dataBase!.journal;
  }

  void _addOrEditJournal(
      {required add, required int index, required Journal journal}) async {
    JournalEdit _journalEdit = JournalEdit(action: '', journal: journal);
    _journalEdit = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EditEntry(add: add, index: index, journalEdit: _journalEdit),
          fullscreenDialog: true),
    );
    switch (_journalEdit.action) {
      case 'Save':
        if (add) {
          setState(
            () {
              _dataBase!.journal.add(_journalEdit.journal);
            },
          );
        } else {
          setState(() {
            _dataBase!.journal[index] = _journalEdit.journal;
          });
        }
        DataBaseFileRoutine()
            .writeJournals(_dataBase!.toJson()); // Updated this line
        break;
    }
  }

  Widget _buildListViewSeperated(AsyncSnapshot snapshot) {
    return ListView.separated(
        itemCount: snapshot.data.lenght,
        itemBuilder: (context, index) {
          String _titleDate = DateFormat.yMMMd()
              .format(DateTime.parse(snapshot.data[index].date));
          String _subtitle =
              snapshot.data[index].mood + "\n" + snapshot.data[index].note;
          return Dismissible(
            key: Key(snapshot.data[index].id),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
            ),
            child: ListTile(
              subtitle: Text(_subtitle),
              onTap: () {
                _addOrEditJournal(
                  add: false,
                  index: index,
                  journal: snapshot.data[index],
                );
              },
              title: Text(
                _titleDate,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Column(children: [
                Text(
                  DateFormat.d().format(
                    DateTime.parse(snapshot.data[index].date),
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  DateFormat.E().format(
                    DateTime.parse(snapshot.data[index].date),
                  ),
                ),
              ]),
            ),
            onDismissed: (direction) {
              setState(() {
                _dataBase!.journal.removeAt(index);
              });
              DataBaseFileRoutine().writeJournals(_dataBase!
                  .toJson()); // Use toJson() instead of databaseToJson()
            },
          );
        },
        separatorBuilder: ((context, index) {
          return Divider(
            color: Colors.grey,
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        initialData: const [],
        future: _loadJournals(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _buildListViewSeperated(snapshot);
        },
      ),
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.all(24.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Jounal Entry",
        onPressed: () {
          _addOrEditJournal(
              add: true,
              index: -1,
              journal: Journal(date: '', mood: '', id: '', note: ''));
        },
      ),
    );
  }
}
