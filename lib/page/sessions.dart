import 'package:flutter/material.dart';
import 'package:test_drive/page/camera_page.dart' as camera;
import 'package:test_drive/page/input_number.dart';

import '../service/session_service.dart';


class Sessions extends StatefulWidget {
  const Sessions({super.key});

  @override
  State<Sessions> createState() => _Session();
}

class _Session extends State<Sessions> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      service.saveToSharedPreferences();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Стопки'),
      ),
      body: ListView.builder(
        itemCount: service
            .getSessions()
            .length,
        itemBuilder: (context, index) {
          return ItemWidget(
              name: service.getSessionName(index),
              onChangeName: (String newName) {
                service.changeNameSession(newName, index);
                setState(() {});
              },
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
            onReversePressed: service.reverseCurrent,
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
  final String name;
  final Function onChangeName;
  final Function onDeletePressed;
  final Function onOpenPressed;
  final Function onReversePressed;

  const ItemWidget({super.key,
    required this.name,
    required this.onChangeName,
    required this.onDeletePressed,
    required this.onOpenPressed, required this.onReversePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      onTap: () {
        _showEditDialog(context);
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => onDeletePressed(),
          ),
          IconButton(
            icon: Icon(Icons.cached),
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

  void _showEditDialog(BuildContext context) async {
    String? newText = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController textEditingController = TextEditingController(text: name);
        textEditingController.selection = TextSelection(baseOffset: 0, extentOffset: name.length);
        return AlertDialog(
          alignment: Alignment.topCenter,
          title: Text('Введите новое имя стопки'),
          content: TextField(
            controller: textEditingController,
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: Text('Сохранить'),
              onPressed: () {
                Navigator.of(context).pop(textEditingController.text);
              },
            ),
          ],
        );
      },
    );
    if (newText != null) {
      onChangeName(newText);
    }
  }
}

class Session extends StatelessWidget {
  const Session({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service.getCurrent().name),
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
              child: Text('Добавить листы'),
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
              child: Text('Найти по коду'),
            ),
          ],
        ),
      ),
    );
  }
}