import 'package:flutter/material.dart';
import 'package:test_drive/page/camera_page.dart' as camera;
import 'package:test_drive/page/input_number.dart';

import '../service/session_service.dart';


class Sessions extends StatefulWidget {
  const Sessions({super.key});

  @override
  State<Sessions> createState() => _Session();
}

class _Session extends State<Sessions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sessions'),
      ),
      body: ListView.builder(
        itemCount: service
            .getSessions()
            .length,
        itemBuilder: (context, index) {
          return ItemWidget(
              date: service.getSessionDate(index),
              onDeletePressed: () {
                service.removeSession(index);
                setState(() {});
              },
              onOpenPressed: () {
                service.setCurrent(index);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Session()
                    )
                );
              },
            onReversePressed: service.reverseCurrent(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          service.newSession();
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final String date;
  final Function onDeletePressed;
  final Function onOpenPressed;
  final Function onReversePressed;

  const ItemWidget({super.key,
    required this.date,
    required this.onDeletePressed,
    required this.onOpenPressed, required this.onReversePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(date),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => onDeletePressed(),
          ),
          IconButton(
            icon: Icon(Icons.abc_sharp),
            onPressed: () => onReversePressed(),
          ),
          IconButton(
            icon: Icon(Icons.open_in_new),
            onPressed: () => onOpenPressed(),
          ),
        ],
      ),
    );
  }
}

class Session extends StatelessWidget {
  const Session({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const camera.CameraApp()
                    )
                );
              },
              child: Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NumberSearchPage()
                    )
                );
              },
              child: Text('Vision'),
            ),
          ],
        ),
      ),
    );
  }
}