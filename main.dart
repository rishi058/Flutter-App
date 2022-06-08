import 'package:flutter/material.dart';
import 'sql_helper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note2/second.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // All Notes ->
  List<Map<String, dynamic>> notes = [];

  bool isLoading = true;

  // This function is used to fetch all data from the database.

  void refreshNotes() async {
    final data = await SQLHelper.getItems();

    setState(() {
      notes = data;
      isLoading = false;
    });
  }

  String length(String s) {
    if (s.length > 320) {
      return '${s.substring(1, 320)}...';
    } else {
      return s;
    }
  }

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  //  -----------------------------  U I --------------------------------------


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes App',
          style: TextStyle(color: Colors.white70),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Second(
                            index: -1,
                            func: refreshNotes,
                          )),
                );
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ) // if else is used --> if (loading==true){show buffering} else {build}

          : MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Second(
                                index: index,
                                func: refreshNotes,
                              )),
                    );
                  },
                  child: Card(
                    color: HexColor(notes[index]['color'].substring(8, 16)),
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(6),
                          child: Center(
                            child: Text(
                              notes[index]['title'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(height: 6),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            length(notes[index]['description']),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
