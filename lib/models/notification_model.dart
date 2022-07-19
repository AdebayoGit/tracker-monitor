class Notification {

  final String title;

  final String body;

  final DateTime createdAt;


  Notification({
    required this.title,

    required this.body,

    required this.createdAt,
  });

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(

      title: map['title'],

      body: map['body'],

      createdAt: map['createdAt'],
    );
  }
}