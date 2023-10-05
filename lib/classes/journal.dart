
/*
 * The Journal class is responsible for tracking individual journal entries through the String id, date,
mood, and note variables. You use the Journal.fromJson() named constructor to take the argument of
Map<String, dynamic>, which maps the String key with a dynamic value, the JSON key/value pair.
You use the toJson() method to convert the Journal class into a JSON object.
 */

class Journal {
  String id;
  String date;
  String mood;
  String note;
  Journal({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
  });
// To retrieve and convert the JSON object to a Journal class,
  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
      id: json["id"],
      date: json["date"],
      mood: json["mood"],
      note: json["note"]);
//Journal class to a JSON object.
  Map<String, dynamic> toJson() => {
    "id":id,"date":date,"mood": mood,"note":note
  };
}
// a builder provides (BuildContext context, AsynchSnapshot snapshot) to retrieve data and connection state
// to check whether data is returned snapshot.data, to check the connectionstate snapshot,connectionstate
// to check if it's active waiting , done or none use: snapshot.hasError
//builder: (BuildContext context, AsyncSnapshot snapshot){
  //return !snapshot.hasData? CircularProgressIndicator() :_buildListView(sna)
//}
// futre: Calls a future asyunchronous method to retreive data

 /*FutureBuilder(initialData[], future: , builder: (BuildContext context, AsyncSnapshot snapshot){
  return !snapshat.hasData? CircularProgressIndicator: _buildListView(snapshot);
 })*/