import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/data_model.dart';
import 'package:flutter_application_1/provider/filepath_model.dart';
import 'package:path/path.dart' as path;
import 'package:file_manager/file_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class FileManagerWidget extends StatelessWidget {
  final FileManagerController controller;
  final FilePathModel filePathModel;
  final DataModel datamodel;
  const FileManagerWidget({
    Key? key,
    required this.controller,
    required this.filePathModel,
    required this.datamodel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: datamodel,
      child: Scaffold(
        appBar: _appBar(context),
        body: FileManager(
          controller: controller,
          builder: (context, snapshot) {
            final List<FileSystemEntity> entities = snapshot;
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              itemCount: entities.length,
              itemBuilder: (context, index) {
                FileSystemEntity entity = entities[index];
                return Card(
                  child: ListTile(
                    leading: FileManager.isFile(entity)
                        ? Icon(Icons.feed_outlined)
                        : Icon(Icons.folder),
                    title: Text(FileManager.basename(
                      entity,
                      showFileExtension: true,
                    )),
                    subtitle: _subtitle(entity),
                    onTap: () async {
                      if (FileManager.isDirectory(entity)) {
                        controller.openDirectory(entity);
                      } else {
                        String fileType = path.extension(entity.path).toLowerCase();
                        String type;
                        
                        // Determine file type based on extension
                        switch (fileType) {
                          case 'jpg':
                          case 'jpeg':
                          case 'png':
                          case 'gif':
                            type = 'image';
                            break;
                          case 'mp4':
                          case 'mov':
                          case 'avi':
                          case 'wmv':
                            type = 'video';
                            break;
                          case 'pdf':
                            type = 'document';
                            break;
                          default:
                            type = 'other';
                            break;
                        }
                        
                        // Create file data
                        Map<String, dynamic> newFile = {
                          "img": entity.path,  // Using file path as image path
                          "type": type,
                          "title": path.basename(entity.path),
                        };
                                            
                        context.read<DataModel>().setFilePath(entity.path);
                        context.read<DataModel>().addContent(newFile);
                        Navigator.pop(context);
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final status = await Permission.storage.status;
            const statusManageStorage = Permission.manageExternalStorage;
            if (status.isDenied ||
                !status.isGranted ||
                !await statusManageStorage.isGranted) {
              await [
                Permission.storage,
                Permission.mediaLibrary,
                Permission.requestInstallPackages,
                Permission.manageExternalStorage,
              ].request();
            }
          },
          label: Text("Request File Access Permission"),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => _createFolder(context),
          icon: Icon(Icons.create_new_folder_outlined),
        ),
        IconButton(
          onPressed: () => _sort(context),
          icon: Icon(Icons.sort_rounded),
        ),
        IconButton(
          onPressed: () => _selectStorage(context),
          icon: Icon(Icons.sd_storage_rounded),
        )
      ],
      title: ValueListenableBuilder<String>(
        valueListenable: controller.titleNotifier,
        builder: (context, title, _) => Text(title),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () async {
          await controller.goToParentDirectory();
        },
      ),
    );
  }

  Widget _subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;
            return Text("${FileManager.formatBytes(size)}");
          }
          return Text("${snapshot.data!.modified}".substring(0, 10));
        } else {
          return Text("");
        }
      },
    );
  }

  Future<void> _selectStorage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: FutureBuilder<List<Directory>>(
          future: FileManager.getStorageList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<FileSystemEntity> storageList = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: storageList
                      .map((e) => ListTile(
                            title: Text("${FileManager.basename(e)}"),
                            onTap: () {
                              controller.openDirectory(e);
                              Navigator.pop(context);
                            },
                          ))
                      .toList(),
                ),
              );
            }
            return Dialog(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void _sort(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: Text("Name"),
                  onTap: () {
                    controller.sortBy(SortBy.name);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text("Size"),
                  onTap: () {
                    controller.sortBy(SortBy.size);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text("Date"),
                  onTap: () {
                    controller.sortBy(SortBy.date);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text("type"),
                  onTap: () {
                    controller.sortBy(SortBy.type);
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _createFolder(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController folderName = TextEditingController();
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: TextField(
                    controller: folderName,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await FileManager.createFolder(
                          controller.getCurrentPath, folderName.text);
                      controller.setCurrentPath =
                          controller.getCurrentPath + "/" + folderName.text;
                    } catch (e) {}

                    Navigator.pop(context);
                  },
                  child: Text('Create Folder'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
