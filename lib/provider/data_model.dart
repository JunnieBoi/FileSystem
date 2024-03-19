import 'package:flutter/material.dart';

class DataModel extends ChangeNotifier {
  List sampleFilesContentJson = [
  {
    "img" : "assets/images/file_image.png",
    "type" : "image" ,
    "file_count" : "455",
    "title" : "Holiday"
  },
  {
    "img" : "assets/images/file_image.png",
    "type" : "image" ,
    "file_count" : "32",
     "title" : "Education"
  },
  {
    "img" : "assets/images/file_video.png",
    "type" : "video" ,
    "file_count" : "27",
     "title" : "Youtube"
  },
  {
    "img" : "assets/images/file_contact.png",
    "type" : "contact" ,
    "file_count" : "69",
     "title" : "Family"
  },
];

List _sampleFolderContentJson = [
  {
    "title" : "Holiday",
    "content":[]
  },
  {
     "title" : "Education",
     "content":[]
  },
  {
     "title" : "Youtube",
     "content":[]
  },
  {
     "title" : "Family",
     "content":[]
  },
];
  String _filePath = "";
  String get filePath => _filePath;
  String? _title;
  String? get title => _title;

  List get sampleFolderContentJson => _sampleFolderContentJson;

  Future<void> setFilePath(String fp) {
    _filePath = fp;
    notifyListeners();
    return Future.value();
  }
  Future<String> setTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
    return Future.value(newTitle);
    
  }
  Future<void> addContent(Map path) {
  // Find the index of the folder with the specified title
  int index = _sampleFolderContentJson.indexWhere((folder) => folder['title'] == _title);
  
  if (index != -1) {
    // If the folder exists, add the path to its content list
    _sampleFolderContentJson[index]['content'].add(path);
    // Notify listeners that the data has changed
    notifyListeners();
  }

  return Future.value();

  

}

Future<int> locateIndex() {
  // Find the index of the folder with the specified title
  int index = _sampleFolderContentJson.indexWhere((folder) => folder['title'] == _title);
  notifyListeners();
  return Future.value(index);

}
}