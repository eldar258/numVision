import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../service/session_service.dart';

class NumberSearchPage extends StatefulWidget {
  const NumberSearchPage({super.key});

  @override
  _NumberSearchPageState createState() => _NumberSearchPageState();
}

class _NumberSearchPageState extends State<NumberSearchPage> {
  String searchText = '';
  List<List<int>> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vision'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                if (value.length == 4) {
                  searchResults = service.search(int.parse(value));
                } else {
                  searchResults = [];
                }
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter 4 digits',
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Search Results:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("id:${searchResults[index][0]} list:${searchResults[index][1]}"),
                  onTap: () {
                    service.removeLine(searchResults[index][1], searchResults[index][2]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}