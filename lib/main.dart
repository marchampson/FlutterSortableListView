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
      // Decrement index so that after removing we'll still insert the item
      // in the correct position.
      if (index > data) {
        index--;
      }
      String imageToMove = rows[data];
      rows.removeAt(data);
      rows.insert(index, imageToMove);
    });
  }

  Widget _getListItem(int index, [double elevation = 2.0]) {
    // A little hack: our ListView has an extra invisible trailling item to
    // allow moving the dragged item to the last position.
    if (index == rows.length) {
      // This invisible item uses the previous item to determine its size. If
      // the list is empty, though, there's no dragging really.
      if (rows.isEmpty) {
        return new Container();
      }
      return new Opacity(
        opacity: 0.0,
        child: _getListItem(index - 1),
      );
    }

    return new Card(
      child: new Column(
        children: <Widget>[
          new ListTile(
              leading: new Icon(Icons.photo), title: new Text(rows[index])),
        ],
      ),
      elevation: elevation,
    );
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
        body: new LayoutBuilder(builder: (context, constraint) {
          return new ListView.builder(
            itemCount: rows.length + 1,
            addRepaintBoundaries: true,
            itemBuilder: (context, index) {
              return new LongPressDraggable<int>(
                data: index,
                child: new DragTarget<int>(
                  onAccept: (int data) {
                    _handleAccept(data, index);
                  },
                  builder: (BuildContext context, List<int> data,
                      List<dynamic> rejects) {
                    List<Widget> children = [];

                    // If the dragged item is on top of this item, the we draw
                    // a half-visible item to indicate that dropping the dragged
                    // item will add it in this position.
                    if (data.isNotEmpty) {
                      children.add(
                        new Container(
                          decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.grey[600], width: 2.0),
                          ),
                          child: new Opacity(
                            opacity: 0.5,
                            child: _getListItem(data[0]),
                          ),
                        ),
                      );
                    }
                    children.add(_getListItem(index));

                    return new Column(
                      children: children,
                    );
                  },
                ),
                onDragStarted: () {
                  Scaffold.of(context).showSnackBar(
                        new SnackBar(
                            content: new Text("Drag the row to change places")),
                      );
                },
                feedback: new Opacity(
                  opacity: 0.75,
                  child: new SizedBox(
                    width: constraint.maxWidth,
                    child: _getListItem(index, 18.0),
                  ),
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
