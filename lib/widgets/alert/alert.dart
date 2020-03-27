import 'package:flutter/material.dart';

class BasicAlert extends StatelessWidget {
  const BasicAlert({@required this.content,@required this.title});
  final String content;
  final String title;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(content),
      title: Text(title),
      actions: <Widget>[
        FlatButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: const Text('ok'))
      ],
    );
  }
}