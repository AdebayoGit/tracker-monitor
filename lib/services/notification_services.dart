import 'package:firebase_messaging/firebase_messaging.dart';


class NotificationServices{

  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future initialize() async{
    fcm.getInitialMessage().then((RemoteMessage? message){
      if(message?.notification != null){
        //Todo: Add body
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null){
        //Todo: Add body
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if(message.notification != null){
        //Todo: Add body
      }
    });
  }

  Future<String?> getToken() async{
    return await fcm.getToken();
  }

  Future<void> subScribeToTopic(String topic) async{
    fcm.subscribeToTopic(topic);
  }
}
