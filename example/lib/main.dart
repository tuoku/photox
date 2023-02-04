import 'package:flutter/material.dart';
import 'package:photox/photox.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: PhotoX(items: [
                  PhotoxItem(
                      id: "1", resource: "assets/img1.jpeg", isAsset: true),
                  PhotoxItem(
                      id: "2", resource: "assets/img2.jpg", isAsset: true)
                ]))
          ],
        ),
      ),
    );
  }
}
