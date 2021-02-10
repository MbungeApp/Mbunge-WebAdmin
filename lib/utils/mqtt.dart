// import 'package:mqtt_client/mqtt_browser_client.dart';
// import 'package:mqtt_client/mqtt_client.dart';

// class MQTTclient {
//   static final client = MqttBrowserClient('ws://test.mosquitto.org', '');

//   Future<void> initConnection() async {
//     client.logging(on: false);
//     client.keepAlivePeriod = 20;
//     client.port = 8080;
//     client.onDisconnected = onDisconnected;
//     client.onConnected = onConnected;
//     client.onSubscribed = onSubscribed;
//     client.pongCallback = pong;

//     final connMess = MqttConnectMessage()
//         .withClientIdentifier('Mqtt_MyClientUniqueId')
//         .keepAliveFor(20) // Must agree with the keep alive set above or not set
//         .withWillTopic(
//             'willtopic') // If you set this you must set a will message
//         .withWillMessage('My Will message')
//         .startClean() // Non persistent session for testing
//         .withWillQos(MqttQos.atLeastOnce);
//     print('EXAMPLE::Mosquitto client connecting....');

//     try {
//       await client.connect();
//     } on Exception catch (e) {
//       print('EXAMPLE::client exception - $e');
//       client.disconnect();
//     }
//   }

//   /// The subscribed callback
//   void onSubscribed(String topic) {
//     print('EXAMPLE::Subscription confirmed for topic $topic');
//   }

//   /// The unsolicited disconnect callback
//   void onDisconnected() {
//     print('EXAMPLE::OnDisconnected client callback - Client disconnection');
//     if (client.connectionStatus.disconnectionOrigin ==
//         MqttDisconnectionOrigin.solicited) {
//       print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
//     }
//   }

//   /// The successful connect callback
//   void onConnected() {
//     print(
//         'EXAMPLE::OnConnected client callback - Client connection was sucessful');
//   }

//   /// Pong callback
//   void pong() {
//     print('EXAMPLE::Ping response client callback invoked');
//   }
//   // TODO
//   // 1. init
//   // subscribe to topics
//   // unsubscribe
// }
