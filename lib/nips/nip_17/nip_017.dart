import 'dart:async';
import 'dart:convert';

import 'package:dart_ndk/additional_functions.dart';
import 'package:dart_ndk/nips/event_kinds.dart';
import 'package:dart_ndk/nips/nip01/bip340_event_signer.dart';
import 'package:dart_ndk/nips/nip01/event.dart';
import 'package:dart_ndk/nips/nip_44/nip_044.dart';
import 'package:dart_ndk/nips/nip_59/nip_059.dart';

class Nip17 {
  static Future<Nip01Event?> encode(
    Nip01Event event,
    String receiver,
    Bip340EventSigner signer, {
    int? kind,
    int? expiration,
    int? createAt,
  }) async {
    try {
      final sealedGossipEvent = await _encodeSealedGossip(
        event,
        receiver,
        signer,
      );

      if (sealedGossipEvent != null) {
        return await Nip59.encode(
          sealedGossipEvent,
          receiver,
          signer,
          kind: kind?.toString(),
          expiration: expiration,
          createAt: getUnixTimestampWithinOneWeek(),
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Nip01Event?> decode(
    Nip01Event event,
    Bip340EventSigner signer,
  ) async {
    try {
      Nip01Event sealedGossipEvent =
          await Nip59.decode(event, signer.publicKey, signer.privateKey!);

      Nip01Event decodeEvent =
          await _decodeSealedGossip(sealedGossipEvent, signer);
      return decodeEvent;
    } catch (e) {
      return null;
    }
  }

  static Future<Nip01Event?> _encodeSealedGossip(
    Nip01Event event,
    String receiver,
    Bip340EventSigner signer,
  ) async {
    event.sig = '';
    String encodedEvent = jsonEncode(event);
    String content = await Nip44.encryptContent(encodedEvent, receiver, signer);

    final n01 = Nip01Event(
      pubKey: signer.publicKey,
      kind: EventKind.SEALED_EVENT,
      tags: [],
      content: content,
    );

    signer.sign(n01);

    return n01;
  }

  static Future<Nip01Event> _decodeSealedGossip(
    Nip01Event event,
    Bip340EventSigner signer,
  ) async {
    if (event.kind == EventKind.SEALED_EVENT) {
      try {
        String content = await Nip44.decryptContent(
          event.content,
          event.pubKey,
          signer.publicKey,
          signer.privateKey!,
        );

        Map<String, dynamic> map = jsonDecode(content);
        map['sig'] = '';
        Nip01Event innerEvent = Nip01Event.fromJson(map);

        if (innerEvent.pubKey == event.pubKey) {
          return innerEvent;
        }
      } catch (e) {
        throw Exception(e);
      }
    }

    throw Exception("${event.kind} is not nip24 compatible");
  }
}
