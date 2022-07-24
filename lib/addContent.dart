import 'package:bucket_provider_practice/dataBase/dpHelper.dart';
import 'package:bucket_provider_practice/model/modelData.dart';

import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  DBHelper dbHelper; // call by reference

  AddPage({required this.dbHelper, Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController textController = TextEditingController();
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('BucketList Content 작성'),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: textController,
            decoration:
                InputDecoration(hintText: 'content를 작성해주세요', errorText: error),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              // '추가하기' 버튼을 눌렀을 떄
              onPressed: () async {
                String job = textController.text;

                if (job.isEmpty) {
                  setState(() {
                    error = '내용을 입력해주세요';
                  });
                } else {
                  setState(() {
                    error = null;
                  });
                }

                await insertBucket(job); // sqflite 파일에 데이터를 추가하는 함수

                print('insertBucket()을 수행했습니다.');

                Navigator.pop(context);
              },
              child: Text('추가하기')),
        )
      ]),
    );
  }

  // '추가하기' 버튼을 누르면 sqflite 파일에 데이터를 추가하는 함수
  Future<void> insertBucket(String job) async {
    await widget.dbHelper.insertBucket(Bucket(job, false));
  }
}

// Custom AppBar
AppBar myAppBar(String text) {
  return AppBar(
      backgroundColor: Colors.white24,
      centerTitle: true,
      title: Text(
        text,
        style: TextStyle(
            color: Colors.amber, fontSize: 25.0, fontWeight: FontWeight.bold),
      ));
}
