import 'dart:convert';

import 'package:dart_ndk/nips/nip01/event.dart';
import 'package:dart_ndk/relays_classes.dart';

// Used to deserialize any kind of message that a nostr client or relay can transmit.
class Message {
  late String type;
  late dynamic message;

// nostr message deserializer
  Message.deserialize(String payload) {
    dynamic data = jsonDecode(payload);
    var messages = ['EVENT', 'REQ', 'CLOSE', 'NOTICE', 'EOSE', 'OK', 'AUTH'];
    assert(messages.contains(data[0]), 'Unsupported payload (or NIP)');

    type = data[0];

    switch (type) {
      case 'EVENT':
        message = Nip01Event.deserialize(data);
        break;
      case 'REQ':
        break;
      case 'CLOSE':
        message = Close.deserialize(data);
        break;
      default:
        message = jsonEncode(data.sublist(1));
        break;
    }
  }
}
