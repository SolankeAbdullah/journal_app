import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'database.dart';

/*
The DatabaseFileRoutines class handles locating the device’s local document directory path through
the path_provider package. You used the File class to handle the saving and reading of the database
file by importing the dart:io library. The file is text-based containing the key/value pair of
JSON objects.

 */

//DatabaseFileRoutines class, add the _localPath async method that returns a
//Future<String>, which is the documents directory path.

class DataBaseFileRoutine {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //localFile async method that returns a Future<File> with the reference to the local_
//persistence.json file, which is the path, combined with the filename.

  Future<File> get _localFile async {
    final path = await _localPath; // Corrected variable name
    return File("$path/local_persistence.json");
  }

  //the readJournals() async method that returns a Future<String> containing the JSON
//objects. You’ll use a try-catch just in case there is an issue with reading the file.

  Future<String> readJournals() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        print("File does not exist ${file.absolute}");
        await writeJournals('{"journals": []}');
      }
      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("Error readJournals: $e");
      rethrow; // Rethrow the exception to propagate it further
    }
  }

  Future<File> writeJournals(String json) async {
    final file = await _localFile;
    //write the file
    return file.writeAsString('$json');
  }
// To read and parse from JSON data - dataBaseFromJson(jsonString)

  DataBase databaseFromJson(String str) {
    final dataFromJson = json.decode(str) as Map<String, dynamic>;
    return DataBase.fromJson(dataFromJson);
  }

  String databaseToJson(DataBase data) {
    final dataToJson = data.toJson();
    return json.encode(dataToJson);
  }
}
