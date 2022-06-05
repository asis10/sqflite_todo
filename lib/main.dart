// ignore_for_file: prefer_const_constructors

import 'package:dbtutorial/dbhelp.dart';
import 'package:dbtutorial/grocery.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(SqliteApp());
}

class SqliteApp extends StatefulWidget {
  const SqliteApp({Key? key}) : super(key: key);

  @override
  State<SqliteApp> createState() => _SqliteAppState();
}

class _SqliteAppState extends State<SqliteApp> {
  final textcontroller = TextEditingController();
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
            style: TextStyle(color: Colors.white),
            controller: textcontroller,
            cursorColor: Colors.white,
          ),
          backgroundColor: Color.fromARGB(255, 91, 170, 222),
          centerTitle: true,
          shadowColor: Colors.grey,
        ),
        body: Center(
          child: FutureBuilder<List<Grocery>>(
            future: DatabaseHelper.instance.getGroceries(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Grocery>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                );
              }
              return snapshot.data!.isEmpty
                  ? Container(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(color: Colors.blue),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text("No Items In List",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ))
                  : ListView(
                      children: snapshot.data!.map((grocery) {
                      return Center(
                        child: ListTile(
                          title: Text(grocery.name),
                          onTap: (){
                            setState(() {
                              textcontroller.text = grocery.name;
                              selectedId = grocery.id;
                            });
                          },
                          onLongPress: () {
                            setState(() {
                              DatabaseHelper.instance.remove(grocery.id!);
                            });
                            ;
                          },
                        ),
                      );
                    }).toList());
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.save,
          ),
          onPressed: () async {
            selectedId != null ?
            await DatabaseHelper.instance.update(Grocery(id: selectedId , name: textcontroller.text)):
            await DatabaseHelper.instance.add(Grocery(name: textcontroller.text));
            setState(() {
              textcontroller.clear();
            });
          },
        ),
      ),
    );
  }
}
