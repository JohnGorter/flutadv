# Persistence

---
### Persistence
Options to store data
- UI state persistence
- Shared Preferences
- File IO
- SQL Lite
- Restfull services

---
### UI State persistence
- PageStorageBucket 
    - generic key value pair store for widgets
- PageStorageKey<T> class
    - Automates PageStorageBucket

- Examples
    - hold scroll positions in lists
    - hold collapsible tile states (ExpansionTile)

---
### UI State persistence
Manually store and read widget state
```
    ...  // inside statefull widget state
    final PageStorageBucket bucket = PageStorageBucket();
    ...
    body: PageStorage(
        bucket:bucket,
        child: CurrentPage(),
    )
    ..
```

---
### UI State persistence
Manually store and read widget state (2)
```
    ...  // inside a child widget
    
    ...
    return ExpansionTile(
        title:Text("click me"),
        onExpansionChanged:(b){
            setState((){
                PageStorage.of(context).writeState(context, b, identifier: ValueKey("someid");
            });
        initiallyExpanded: PageStorage.of(context).readState(context, identifier: ValueKey("someid");
        },
    );
    ..
```

---
### PageStorage Keys
- Used to save and restore values that can outlive the widget. 
- Values are stored in a per-route Map 
- Keys are defined by the PageStorageKeys 
- Key's values must not be objects if identity changes when widget (re)created


---
### PageStorage Keys
Example
```
new TabBarView(
  children: myTabs.map((Tab tab) {
    new MyScrollableTabView(
      key: new PageStorageKey<String>(tab.text), // like 'Tab 1'
      tab: tab,
   ),
 }),
)
```
---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. UI Persistence

---
### Shared Preferences

- Wraps NSUserDefaults (on iOS) and SharedPreferences (on Android)
- Provides a persistent store for simple data. 
- Data is persisted to disk asynchronously. 
- No guarantee that writes will be persisted to disk
- Not be used for storing critical data.

---
### Shared Preferences Usage
Usage
- Add shared_preferences as a dependency
- Use plugin

---
### Example Shared Preferences
```
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(new MaterialApp(
    home: new Scaffold(
      body: new Center(
      child: new RaisedButton(
        onPressed: _incrementCounter,
        child: new Text('Increment Counter'),
        ),
      ),
    ),
  ));
}

_incrementCounter() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + 1;
  print('Pressed $counter times.');
  await prefs.setInt('counter', counter);
}
```

---
### Testing Shared Preferences
You can populate SharedPreferences with initial values in your tests by running this code:
```
const MethodChannel('plugins.flutter.io/shared_preferences')
  .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{}; // set initial values here if desired
    }
    return null;
  });
```

https://github.com/flutter/plugins/tree/master/packages/shared_preferences

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. Shared Preferences

---
### File IO
Combination of
- path_provider plugin 
- dart:io library

---
### Path_provider plugin
Access to two filesystem locations

- Temporary directory (cache): 
    - On iOS -> NSTemporaryDirectory 
    - On Android -> getCacheDir
- Documents directory: 
    - Directory cleared only when the app is deleted
    - On iOS -> NSDocumentDirectory 
    - On Android -> AppData 

---
### Example Path_provider
Getting the Documents directory and writing a file
```
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return new File('$path/counter.txt');
}
```

---
### Example 2 Path_provider
Reading files
```
Future<int> readCounter() async {
  try {
    final file = await _localFile;

    // Read the file
    String contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // If we encounter an error, return 0
    return 0;
  }
}
```

---
### Testing Path_provider
To test
- Mock calls to the MethodChannel
- Interact with our test environment’s filesystem
- use setUpAll setup method:

```
setUpAll(() async {
  // Create a temporary directory to work with
  final directory = await Directory.systemTemp.createTemp();
  
  // Mock out the MethodChannel for the path_provider plugin
  const MethodChannel('plugins.flutter.io/path_provider')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    // If we're getting the apps documents directory, return the path to the
    // temp directory on our test environment instead.
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      return directory.path;
    }
    return null;
  });
});
```

https://flutter.io/reading-writing-files/

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. File IO

---
### SqfLite Persistence
- SqfLite Plugin that supports both iOS and Android
    - Support transactions and batches
    - Automatic version managment during open
    - Helpers for insert/query/update/delete queries
    - DB operation executed in a background thread on iOS and Android

---
### SqfLite Persistence
Add the dependency in pubspec.yaml
```
dependencies:
  ...
  sqflite: any
```

---
### SqfLite Persistence
Use transactions to insert rows...
```
// Insert some records in a transaction
await database.transaction((txn) async {
  int id1 = await txn.rawInsert(
      'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
  print("inserted1: $id1");
  int id2 = await txn.rawInsert(
      'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
      ["another name", 12345678, 3.1416]);
  print("inserted2: $id2");
});
```

---
### SqfLite Persistence
Update records
```
// Update some record
int count = await database.rawUpdate(
    'UPDATE Test SET name = ?, VALUE = ? WHERE name = ?',
    ["updated name", "9876", "some name"]);
print("updated: $count");
```

---
### SqfLite
Querying for records
```
List<Map> list = await database.rawQuery('SELECT * FROM Test');
List<Map> expectedList = [
  {"name": "updated name", "id": 1, "value": 9876, "num": 456.789},
  {"name": "another name", "id": 2, "value": 12345678, "num": 3.1416}
];
print(list);
print(expectedList);
assert(const DeepCollectionEquality().equals(list, expectedList));
```

---
### Sqflite Persistence
Deleting records
```
count = await database
    .rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
assert(count == 1);
```

---
### Sqflite Persistence
Closing the database
```
await database.close();
```

---
### SqfLite Persistence
Batch data
```
batch = db.batch();
batch.insert("Test", {"name": "item"});
batch.update("Test", {"name": "new_item"}, where: "name = ?", whereArgs: ["item"]);
batch.delete("Test", where: "name = ?", whereArgs: ["item"]);
results = await batch.commit();
```

https://github.com/tekartik/sqflite/blob/master/doc/how_to.md

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. SqfLite

---
### Restfull services
- Fetch data from the internet

Steps:
- Add the http package
- Make a network request using the http package
- Convert the response into a custom Dart object
- Fetch and Display the data with Flutter

---
### Restfull services
Step 1: Update the pubspec.yaml with http package

```
dependencies:
  http: <latest_version>
```

---
### Restfull services
2. Use the http package inside your application
```
Future<http.Response> fetchPost() {
  return http.get('https://jsonplaceholder.typicode.com/posts/1');
}
```
Future is JavaScripts Promise, you can await it.

---
### Restfull services
Step 3. Convert the JSON to PODO
```
class Post {
  final int id;
  final String title;

  Post({this.id, this.title});

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
      id: json['id'],
      title: json['title'],
    );
  }
}
```

---
### Restfull services
Step 4. Convert the response to an object
```
Future<Post> fetchPost() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/posts/1');
  final responseJson = json.decode(response.body); 
  
  return new Post.fromJson(responseJson); 
}
```

---
###  Restfull services
Step 5. Use the FutureBuilder Widget
```
new FutureBuilder<Post>(
  future: fetchPost(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return new Text(snapshot.data.title);
    } else if (snapshot.hasError) {
      return new Text("${snapshot.error}");
    }
    // By default, show a loading spinner
    return new CircularProgressIndicator();
  },
);
```

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. Layout Widgets


---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!
