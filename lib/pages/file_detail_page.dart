import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/recent_files_json.dart';
import 'package:flutter_application_1/pages/main1.dart';
import 'package:flutter_application_1/provider/data_model.dart';
import 'package:flutter_application_1/provider/filepath_model.dart';
import 'package:flutter_application_1/theme/colors.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/data_model.dart';
import 'package:provider/provider.dart';

class FileDetailPage extends StatefulWidget {
  const FileDetailPage({Key? key}) : super(key: key);

  @override
  State<FileDetailPage> createState() => _FileDetailPageState();
}

class _FileDetailPageState extends State<FileDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_left, color: Colors.black),
        ),
        title: Text(
          "Folder",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Consumer<DataModel>(
            builder: (context, dataModel, child) {
              return getDateSection(context, dataModel);
            },
          ),
          SizedBox(height: 20),
          _futureBuilder(context), // Use the builder function here
        ],
      ),
    );
  }

  Widget _futureBuilder(BuildContext context) {
    return FutureBuilder<Widget>(
      future: getItemLists(context),
      builder: (context, snapshot) {
        print(context.widget);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error: ${snapshot.error}');
        } else {
          return snapshot.data ?? Container();
        }
      },
    );
  }

  Widget getDateSection(BuildContext context, DataModel dataModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "Date Modified",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 2),
            Icon(LineIcons.arrowDown, size: 20),
          ],
        ),
        IconButton(
          onPressed: () async {
            // Your onPressed logic here
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FileManagerWidget(
                  controller: FileManagerController(), // Provide your FileManagerController instance here
                  filePathModel: FilePathModel(), // Provide your FilePathModel instance here
                  datamodel: dataModel,
                ),
              ),
            );
          },
          icon: Icon(
            Icons.file_upload,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Future<Widget> getItemLists(BuildContext context) async {
  var size = MediaQuery.of(context).size;

  return Consumer<DataModel>(
    builder: (context, dataModel, child) {
      // Access data from DataModel using dataModel variable
      var setTitle = context.watch<DataModel>().title;
      var aaa = context.watch<DataModel>().sampleFolderContentJson;

      print(setTitle);
      print(aaa);

      // Your logic to generate list items based on DataModel data
      return Container();
    },
  );
}
//   Future<Widget> getItemLists(BuildContext context) async {
//   var size = MediaQuery.of(context).size;
//   // var dataModel = context.read<DataModel>();
//   // var list = await dataModel.sampleFolderContentJson;
//   var setTitle = await context.read<DataModel>().title;
//   var aaa = await context.read<DataModel>().sampleFolderContentJson;
//   // var title = await dataModel.locateIndex();
//   // print(list);
//   print(context.widget); // Print the current widget associated with the context
// print(context.widget.runtimeType); // Print the type of the current widget
//   print(setTitle);
//   print(aaa);
//   // print(title);
//   return Container();
// //   return Wrap(
// //     spacing: 20,
// //     runSpacing: 20,
// //     children: List.generate(list[title]["content"].length, (index) {
// //       return Container(
// //         width: (size.width - 60) / 2,
// //         height: (size.width - 50) / 2,
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Container(
// //               width: (size.width - 60) / 2,
// //               height: 120,
// //               decoration: BoxDecoration(
// //                 color: white,
// //                 borderRadius: BorderRadius.circular(22),
// //                 image: DecorationImage(
// //                   image: NetworkImage(list[title]["content"][index]['img']),
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 10,),
// //             Padding(
// //               padding: const EdgeInsets.only(left: 5),
// //               child: Text(
// //                 list[title]["content"][index]['file_name'],
// //                 style: TextStyle(
// //                   fontSize: 15,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 5,),
// //             Padding(
// //               padding: const EdgeInsets.only(left: 5),
// //               child: Text(
// //                 list[title]["content"][index]['file_size'],
// //                 style: TextStyle(
// //                   fontSize: 13,
// //                   color: secondary.withOpacity(0.5),
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       );
// //     }),
// //   );
// }
}