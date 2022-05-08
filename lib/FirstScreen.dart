import 'dart:async';

import 'package:flutter/material.dart';

import 'home.dart';

class FirstScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FirstScreenState();
}

class FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 4),()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyHomePage())));
    super.initState();
  }
  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network('https://cdn.dribbble.com/users/1518775/screenshots/6943430/speakernotes_16-9.gif'),
          SizedBox(height: 8,),
          Text('NOTESAVER')
        ],
      ),));


}
