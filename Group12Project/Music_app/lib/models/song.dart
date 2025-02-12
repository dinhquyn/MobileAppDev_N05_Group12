class Song {
  String songname;
  String artist;
  String singer;
  int review;
  String time;
  int date;
  int view;
  String image;

  Song({required this.songname, required this.artist, required this.singer, required this.review, required this.time, required this.date, required this.view, required this.image});
}

List<Song> songList = [
  Song(songname: "Em của ngày hôm qua", artist: "Sơn Tùng MTP", singer: "Sơn Tùng MTP", review: 123, time:"3:45", date: 2014, view: 10, image:"assets/sontungmtp.jpg"),
  Song(songname: "Mất kết nối", artist: "Dương Domic", singer: "Dương Domic", review: 88, time:"4:00", date: 2025, view: 13, image:"assets/duongdomic.jpg"),
  
];