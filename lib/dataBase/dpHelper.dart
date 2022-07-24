import 'package:bucket_provider_practice/model/modelData.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  var _db;

  late List<Map<String, dynamic>> maps;

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = openDatabase(join(await getDatabasesPath(), 'bucketList4.db'),
        onCreate: (db, version) => _createDb(db), version: 1);
    return _db;
  }

  static void _createDb(Database db) {
    db.execute(
      "CREATE TABLE bucketList(id INTEGER PRIMARY KEY, content TEXT, isDone INTEGER)", // id는 값을 주지 않아도 1부터 설정된다.
    );
  }

  Future<void> insertBucket(Bucket bucket) async {
    final db = await database;

    await db.insert("bucketList", bucket.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print('sqflite 파일에 데이터가 추가되었습니다.');
  }

  Future<List<Bucket>> getAllBucket() async {
    final db = await database;

    maps = await db.query('BucketList');

    print('sqflite에 있던 원형 파일 : ${maps}');

    print('mapsLength : ${maps.length}');

    return List.generate(maps.length, (i) {
      return Bucket(maps[i]['content'],
          maps[i]['isDone'] == 1 ? true : false // model로 가져오기 위해서 다시 BOOLEAN으로
          );
    });
  }

  // Future<dynamic> getBucket(int index) async {
  //   final db = await database;

  //   final List<Map<String, dynamic>> maps = (await db.query(
  //     'BucketList',
  //     where: 'id = ?',
  //     whereArgs: [index],
  //   ));

  //   return maps.isNotEmpty ? maps : null;
  // }

  Future<void> updateBucket(Bucket bucket) async {
    // Bucket의 isDone을 false에서 true로 바꾸는 로직
    bucket.isDone = !bucket.isDone;

    final db = await database;

    await db.update(
      "bucketList",
      bucket.toMap(),
      where: "content = ?",
      whereArgs: [bucket.content],
    );
  }

  Future<void> deleteBucket(Bucket bucket) async {
    final db = await database;

    await db.delete(
      "bucketList",
      where: "content = ?",
      whereArgs: [bucket.content],
    );

    print('sqflite 파일에 content가 ${bucket.content}인 데이터가 삭제되었습니다.');
  }
}
