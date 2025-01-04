import 'package:flutter/material.dart';

class Sample extends StatefulWidget {
  const Sample({super.key});

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  int a = 0;
  List sampleData = ["appale", "ball"];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text("data")),
      body: ListView.builder(
          itemCount: sampleData.length,
          itemBuilder: (BuildContext context, index) {
            return ListTile(
              title: Text(sampleData[index]),
            );
          }),
    ));
  }
}
