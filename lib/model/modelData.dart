class Bucket {
  String content;
  bool isDone;

  Bucket(this.content, this.isDone);

  // sqflite 파일에 들어가기 위한 map 형식
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'isDone': isDone ? 1 : 0 // sqflite 파일에는 BOOLEAN을 지원하지 못하기 떄문에 INTEGER로 구분
    };
  }

  @override
  String toString() {
    return 'content : ${content}, isDone: ${isDone}';
  }
}
