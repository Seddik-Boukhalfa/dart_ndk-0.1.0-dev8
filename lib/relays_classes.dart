import 'dart:convert';

import 'package:dart_ndk/nips/message.dart';

typedef OKCallBack = void Function(
  OKEvent ok,
  String relay,
  List<String> unCompletedRelays,
);

class Sends {
  String sendsId;
  List<String> relays;
  int sendsTime;
  String eventId;
  OKCallBack? okCallBack;

  Sends(
    this.sendsId,
    this.relays,
    this.sendsTime,
    this.eventId,
    this.okCallBack,
  );
}

class OKEvent {
  String eventId;
  bool status;
  String message;

  static OKEvent? getOk(String okPayload) {
    var ok = Message.deserialize(okPayload);
    if (ok.type == 'OK') {
      var object = jsonDecode(ok.message);
      return OKEvent(object[0], object[1], object[2]);
    }

    return null;
  }

  OKEvent(this.eventId, this.status, this.message);
}

class Close {
  /// subscription_id is a random string that should be used to represent a subscription.
  late String subscriptionId;

  /// Default constructor
  Close(this.subscriptionId);

  /// Serialize to nostr close message
  /// - ["CLOSE", subscription_id]
  String serialize() {
    return jsonEncode(['CLOSE', subscriptionId]);
  }

  /// Deserialize a nostr close message
  /// - ["CLOSE", subscription_id]
  Close.deserialize(input) {
    assert(input.length == 2);
    subscriptionId = input[1];
  }
}
