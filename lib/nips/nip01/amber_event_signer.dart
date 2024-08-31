import 'dart:convert';

import 'package:amberflutter/amberflutter.dart';
import 'package:dart_ndk/nips/event_kinds.dart';
import 'package:dart_ndk/nips/keychain.dart';
import 'package:dart_ndk/nips/nip01/bip340.dart';
import 'package:dart_ndk/nips/nip01/event.dart';

import '../nip19/nip19.dart';
import 'event_signer.dart';

class AmberEventSigner implements EventSigner {
  final amber = Amberflutter();

  final String publicKey;

  AmberEventSigner(this.publicKey);

  @override
  Future<void> sign(Nip01Event event) async {
    final npub = publicKey.startsWith('npub')
        ? publicKey
        : Nip19.encodePubKey(publicKey);
    Map<dynamic, dynamic> map = await amber.signEvent(
        currentUser: npub, eventJson: jsonEncode(event.toJson()), id: event.id);
    event.sig = map['signature'];
  }

  @override
  String getPublicKey() {
    return publicKey;
  }

  @override
  Future<String?> decrypt04(String msg, String destPubKey, {String? id}) async {
    final npub = publicKey.startsWith('npub')
        ? publicKey
        : Nip19.encodePubKey(publicKey);

    Map<dynamic, dynamic> map = await amber.nip04Decrypt(
      ciphertext: msg,
      currentUser: npub,
      pubKey: destPubKey,
      id: id,
    );
    return map['signature'];
  }

  @override
  Future<String?> encrypt04(String msg, String destPubKey, {String? id}) async {
    final npub = publicKey.startsWith('npub')
        ? publicKey
        : Nip19.encodePubKey(publicKey);

    Map<dynamic, dynamic> map = await amber.nip04Encrypt(
      plaintext: msg,
      currentUser: npub,
      pubKey: destPubKey,
      id: id,
    );

    return map['signature'];
  }

  @override
  Future<String?> decrypt44(String msg, String destPubKey, {String? id}) async {
    final npub = publicKey.startsWith('npub')
        ? publicKey
        : Nip19.encodePubKey(publicKey);

    Map<dynamic, dynamic> map = await amber.nip44Decrypt(
      ciphertext: msg,
      currentUser: npub,
      pubKey: destPubKey,
      id: id,
    );

    return map['event'];
  }

  @override
  Future<String?> encrypt44(String msg, String destPubKey, {String? id}) async {
    final npub = publicKey.startsWith('npub')
        ? publicKey
        : Nip19.encodePubKey(publicKey);

    Map<dynamic, dynamic> map = await amber.nip44Encrypt(
      plaintext: msg,
      currentUser: npub,
      pubKey: destPubKey,
      id: id,
    );

    return map['event'];
  }

  @override
  bool canSign() {
    return publicKey.isNotEmpty;
  }

  @override
  Future<Nip01Event?> decrypt44Event(
    Nip01Event event, {
    String? id,
  }) async {
    final sgString = await decrypt44(event.content, event.pubKey);
    if (sgString != null) {
      final sgEvent = Nip01Event.fromJson(jsonDecode(sgString));
      final decrypt = await decrypt44(sgEvent.content, sgEvent.pubKey);

      if (decrypt != null) {
        return Nip01Event.fromJson(jsonDecode(decrypt));
      }

      return null;
    }
    return null;
  }

  @override
  Future<Nip01Event?> encrypt44Event(
    Nip01Event event,
    String destPubKey, {
    String? id,
  }) async {
    final encrypt = await encrypt44(jsonEncode(event.toJson()), destPubKey);
    if (encrypt != null) {
      final npub = publicKey.startsWith('npub')
          ? publicKey
          : Nip19.encodePubKey(publicKey);

      final ev = Nip01Event(
        pubKey: npub,
        kind: EventKind.SEALED_EVENT,
        tags: [],
        content: encrypt,
      );

      await sign(ev);

      final sgString = await encrypt44(jsonEncode(event.toJson()), destPubKey);

      if (sgString != null) {
        final keys = Keychain.generate();

        return Nip01Event(
          pubKey: keys.public,
          kind: EventKind.GIFT_WRAP,
          tags: [],
          content: sgString,
          sig: Bip340.sign(event.id, keys.private),
        );
      }
    }

    return null;
  }
}
