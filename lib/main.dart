import 'package:flutter_application_1/pages/file_detail_page.dart';
import 'package:flutter_application_1/pages/root_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/data_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RootApp(),
    initialRoute: "/",
      routes: {
        "/filedetails": (context) => ChangeNotifierProvider(
          create: (context) => DataModel(),
          child: FileDetailPage(),
        ),
      }
  ));
}

