import 'package:bucket_provider_practice/addContent.dart';
import 'package:bucket_provider_practice/dataBase/dpHelper.dart';
import 'package:bucket_provider_practice/model/modelData.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Bucket> bucketList = [];
  DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    print('initState() 호출');

    super.initState();

    getAllBucket(); // async 함수
  }

  // sqflite 파일에 접근하여 모든 데이터를 가져와 bucketList에 넣는 함수
  Future<void> getAllBucket() async {
    bucketList = await dbHelper.getAllBucket();

    print(
        'bucketList : ${bucketList}'); // 실제 sqflite에서 모든 데이터를 가져와서 List<Bucket> 형으로 변환한 다음 bucketList에 잘 들어왔는지 확인

    setState(() {}); // build 함수와 연결
  }

  @override
  Widget build(BuildContext context) {
    print('build() 호출');

    return Scaffold(
      appBar: myAppBar('BucketList'),
      body: bucketList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bucketList.length,
              itemBuilder: (BuildContext context, int index) {
                Bucket bucket =
                    bucketList[index]; // element를 꺼내서 ListView를 보여준다.

                return ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${index}'),
                    ),
                    title: Text(
                      bucket.content,
                      style: TextStyle(
                          fontSize: 24.0,
                          color: bucket.isDone ? Colors.grey : Colors.black,
                          decoration: bucket.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),

                    //  휴지통 버튼을 눌렀을 떄 (delete)
                    trailing: IconButton(
                        onPressed: () async {
                          await deleteBucket(bucket); // async 함수

                          await getAllBucket(); // 다시 sqflite 파일에 있는 모든 데이터를 가져와 화면을 다시 build 한다.
                        },
                        icon: Icon(Icons.delete)),

                    // ListTile 화면을 눌렀을 떄 (update)
                    onTap: () async {
                      await updateBucket(bucket);

                      await getAllBucket(); // 다시 sqflite 파일에 있는 모든 데이터를 가져와 화면을 다시 build
                    });
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return AddPage(dbHelper: dbHelper);
          }));

          await getAllBucket(); // sqflite에 있는 모든 파일을 가져와 화면을 다시 build 하는 함수
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
      ),
    );
  }

  // sqflite 파일에 Bucket을 삭제하는 메소드
  Future<void> deleteBucket(Bucket bucket) async {
    await dbHelper.deleteBucket(bucket);
  }

  // sqflite 파일에 Bucket을 업데이트 하는 함수
  Future<void> updateBucket(Bucket bucket) async {
    await dbHelper.updateBucket(bucket);
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
}
