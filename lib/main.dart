import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {

  List<String> rows = new List<String>()
    ..add('Row 1')
    ..add('Row 2')
    ..add('Row 3')
    ..add('Row 4');

  void _handleAccept(int data, int index) {
    setState(() {
      String imageToMove = rows[data];
      rows.removeAt(data);
      rows.insert(index, imageToMove);
    });
  }

  @override
  Widget build(BuildContext context) {

    final title = 'Sortable ListView';

    return new MaterialApp(
      title: title,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
        ),
        body:
        new LayoutBuilder(builder: (context, constraint) {
          return new ListView.builder(
            itemCount: rows.length,
            addRepaintBoundaries: true,
            itemBuilder: (context, index) {
              return new LongPressDraggable(
                key: new ObjectKey(index),
                data: index,
                child: new DragTarget<int>(
                  onAccept: (int data) {
                    _handleAccept(data, index);
                  },
                  builder: (BuildContext context, List<int> data, List<dynamic> rejects) {
                    return new Card(
                        child: new Column(
                          children: <Widget>[
                            new ListTile(
                                leading: new Icon(Icons.photo),
                                title: new Text(rows[index])
                            ),
                          ],
                        )
                    );
                  },
                  onLeave: (int data) {
                    // Debug
                    print('$data is Leaving row $index');
                  },
                  onWillAccept: (int data) {
                    // Debug
                    print('$index will accept row $data');

                    return true;
                  },
                ),
                onDragStarted: () {
                  Scaffold.of(context).showSnackBar(new SnackBar (
                    content: new Text("Drag the row onto another row to change places"),
                  ));

                },
                onDragCompleted: () {
                  print("Finished");
                },
                feedback: new SizedBox(
                    width: constraint.maxWidth,
                    child: new Card (
                      child: new Column(
                        children: <Widget>[
                          new ListTile(
                            leading: new Icon(Icons.photo),
                            title: new Text(rows[index]),
                            trailing: new Icon(Icons.reorder),
                          ),
                        ],
                      ),
                      elevation: 18.0,
                    )
                ),
                childWhenDragging: new Container(),
              );
            },
          );
        }),
      ),
    );
  }
}