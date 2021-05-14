import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:golfpeaofficer/models/record_model.dart';
import 'package:golfpeaofficer/utility/dialog.dart';
//import 'package:golfpeaofficer/utility/test64_dialog.dart';
import 'package:golfpeaofficer/widgets/show_icon_image.dart';
import 'package:golfpeaofficer/widgets/show_title.dart';
import 'package:image_picker/image_picker.dart';

class Type2Widget extends StatefulWidget {
  final RecordModel recordModel;
final String nameJob;
final String idJob;


  Type2Widget({@required this.recordModel , @required this.nameJob , @required this.idJob});

  @override
  _Type2WidgetState createState() => _Type2WidgetState();
}

class _Type2WidgetState extends State<Type2Widget> {
//Global
  RecordModel model;
  List<File> files = [];
  int amountPic = 0;
String nameJob , idDoc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('inistate Type 2 work');
   // setState(() {
      model = widget.recordModel;
//   });

nameJob = widget.nameJob;
idDoc = widget.idJob;

    amountPic = model.quantityImg;

    for (var i = 0; i < amountPic; i++) {
      files.add(null);
    }
  }
/*
    @override
  void dispose() {
    model = null;
   super.dispose();
  }
*/

  Future<Null> createImage(int index, ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxHeight: 800,
        maxWidth: 800,
      );

      setState(() {
        files[index] = File(object.path);
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShowTitle(
              title: model.menuChecklistName,
            ),
            ShowTitle(
              title: 'จำนวนรูปภาพที่ต้องการ ${amountPic} รูป',
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: files.length,
              itemBuilder: (context, index) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('${index + 1}'),
                      Container(
                        width: 120,
                        height: 120,
                        child: files[index] == null
                            ? ShowIconImage()
                            : Image.file(files[index]),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.add_a_photo),
                            onPressed: () =>
                                createImage(index, ImageSource.camera),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_photo_alternate),
                            onPressed: () =>
                                createImage(index, ImageSource.gallery),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),
            buildUpload(),

            /*
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_downward),
                  label: Text('Next123')),
            ],
          )
          */
            /*
          visibles[indexVisibles[index]]
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_downward),
                        label: Text('Next123')),
                  ],
                )
              : SizedBox(),
              */
          ],
        ),
      ),
    );
  }

  ElevatedButton buildUpload() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
      onPressed: () {
        if (files[0] == null) {
          normalDialog(context, 'รูปแรกต้องมี', 'ต้องมีรูปแรก');
        } else {
          List<String> base64Strs = [];
          //  List<File> myFiles = [];
          for (var item in files) {
            if (item != null) {
              //   myFiles.add(item);

              List<int> imageBytes = Io.File(item.path).readAsBytesSync();
              String base64Str = base64Encode(imageBytes);
             normalDialog(context, ' aa', '$base64Str');

         //     print('### Base64 ==> $base64Str');
         //show ภาพ  ********* ใช้นะ
       //  test64Dialog(context, base64Str);
              base64Strs.add(base64Str);
            }
          }
print('### base64Strs.lenght == >${base64Strs.length}');

        }
      },
      child: Text('Upload Data'),
    );
  }
}
