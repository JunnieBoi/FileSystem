import 'package:flutter/material.dart';

class FilePathModel extends ChangeNotifier {
  String _currentFolder = "";
  String _filePath = "";
  int _fileCount = 0;
  String get filePath => _filePath;
  String get currentFolder => _currentFolder;
  int get fileCount => _fileCount;
  void setFilePath(String fp) {
    _filePath = fp;
  }
}