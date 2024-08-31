import 'dart:convert';

import 'package:bip340/bip340.dart' as bip340;
import 'package:dart_ndk/nips/event_kinds.dart';
import 'package:dart_ndk/nips/keychain.dart';
import 'package:dart_ndk/nips/nip01/bip340.dart';
import 'package:dart_ndk/nips/nip01/bip340_event_signer.dart';
import 'package:dart_ndk/nips/nip01/event.dart';
import 'package:dart_ndk/nips/nip01/event_signer.dart';
import 'package:dart_ndk/nips/nip_44/nip_044.dart';

class Nip59 {
  static Future<Nip01Event> encode(
    Nip01Event event,
    String peerPubkey,
    EventSigner signer, {
    String? kind,
    int? expiration,
    int? createAt,
  }) async {
    String encodedEvent = jsonEncode(event);
    Keychain keychain = Keychain.generate();
    final sealedPrivkey = keychain.private;

    String myPubkey = bip340.getPublicKey(sealedPrivkey);
    String content = await Nip44.encryptContent(
      encodedEvent,
      peerPubkey,
      Bip340EventSigner(sealedPrivkey, myPubkey),
    );

    List<List<String>> tags = [
      ["p", peerPubkey]
    ];

    if (kind != null) tags.add(['k', kind]);
    if (expiration != null) tags.add(['expiration', '$expiration']);

    return Nip01Event(
      pubKey: myPubkey,
      kind: EventKind.GIFT_WRAP,
      tags: tags,
      content: content,
      createdAt: createAt ?? 0,
      sig: Bip340.sign(event.id, sealedPrivkey),
    );
  }

  static Future<Nip01Event> decode(
    Nip01Event event,
    String myPubkey,
    String privkey,
  ) async {
    if (event.kind == EventKind.GIFT_WRAP) {
      String content = await Nip44.decryptContent(
        event.content,
        event.pubKey,
        myPubkey,
        privkey,
      );

      Map<String, dynamic> map = jsonDecode(content);
      return Nip01Event.fromJson(map);
    }

    throw Exception("${event.kind} is not nip59 compatible");
  }
}
