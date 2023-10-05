import 'dart:convert';

import 'journal.dart';

/*The Database class uses json.encode and json.decode to serialize and deserialize JSON objects
by importing the dart:convert library. You use the Database.fromJson named constructor to
retrieve and map the JSON objects to a List<Journal>. You use the toJson() method to convert the
List<Journal> to JSON objects.

 */

class DataBase {
  List<Journal> journal;

  DataBase({required this.journal});

  factory DataBase.fromJson(Map<String, dynamic> json) {
    return DataBase(
      journal: List<Journal>.from(
        json["journals"].map((x) => Journal.fromJson(x)),
      ),
    );
  }
  String toJson() {
    return json.encode({
      "journals": List<dynamic>.from(journal.map((x) => x.toJson())),
    });
  }
}
