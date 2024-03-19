import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/data_model.dart';
import 'package:flutter_application_1/provider/filepath_model.dart';
import 'package:flutter_application_1/provider/pageindex_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/data/root_app_json.dart';
import 'package:flutter_application_1/pages/files_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/theme/colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    print(context.widget); // Print the current widget associated with the context
print(context.widget.runtimeType); // Print the type of the current widget
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageIndexModel()),
        ChangeNotifierProvider(create: (context) => FilePathModel()),
        ChangeNotifierProvider(create: (context) => DataModel())
      ],
      child: Scaffold(
        backgroundColor: white,
        bottomNavigationBar: _getTabs(),
        body: _getBody(),
      ));
  }
  Widget _getBody() {
    
    return Consumer<PageIndexModel>(
      builder: (context, pageIndexProvider, child) {
        return IndexedStack(
          index: pageIndexProvider.pageIndex,
          children: [
            HomePage(),
            FilesPage(),
            Center(
              child: Text(
                "Trash Page",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                "Account Page",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _getTabs() {
    return Consumer<PageIndexModel>(
      builder: (context, pageIndexProvider, child) {
        return SalomonBottomBar(
          currentIndex: pageIndexProvider.pageIndex,
          onTap: (index) {
            pageIndexProvider.setPageIndex(index);
          },
          items: List.generate(rootAppJson.length, (index) {
            return SalomonBottomBarItem(
              selectedColor: rootAppJson[index]['color'],
              icon: SvgPicture.asset(
                rootAppJson[index]['icon'],
                color: rootAppJson[index]['color'],
              ),
              title: Text(rootAppJson[index]['text']),
            );
          }),
        );
      },
    );
  }
}