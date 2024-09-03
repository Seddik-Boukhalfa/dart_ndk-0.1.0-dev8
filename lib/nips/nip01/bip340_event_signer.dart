import 'package:dart_ndk/nips/nip01/event.dart';
import 'package:dart_ndk/nips/nip01/helpers.dart';
import 'package:dart_ndk/nips/nip_17/nip_017.dart';
import 'package:dart_ndk/nips/nip_44/nip_044.dart';

import '../nip04/nip04.dart';
import 'bip340.dart';
import 'event_signer.dart';

class Bip340EventSigner implements EventSigner {
  String? privateKey;
  String publicKey;

  Bip340EventSigner(this.privateKey, this.publicKey);

  @override
  Future<void> sign(Nip01Event event) async {
    if (Helpers.isNotBlank(privateKey)) {
      event.sig = Bip340.sign(event.id, privateKey!);
    }
  }

  @override
  String getPublicKey() {
    return publicKey;
  }

  @override
  Future<String?> decrypt04(String msg, String destPubKey, {String? id}) async {
    return Nip04.decrypt(privateKey!, destPubKey, msg);
  }

  @override
  Future<String?> encrypt04(String msg, String destPubKey, {String? id}) async {
    return Nip04.encrypt(privateKey!, destPubKey, msg);
  }

  @override
  Future<String?> decrypt44(
    String msg,
    String destPubKey, {
    String? id,
  }) async {
    return await Nip44.decryptContent(
      msg,
      destPubKey,
      publicKey,
      privateKey!,
    );
  }

  @override
  Future<String?> encrypt44(
    String msg,
    String destPubKey, {
    String? id,
  }) async {
    return await Nip44.encryptContent(msg, destPubKey, this);
  }

  @override
  Future<Nip01Event?> decrypt44Event(
    Nip01Event event, {
    String? id,
  }) async {
    return await Nip17.decode(event, this);
  }

  @override
  Future<Nip01Event?> encrypt44Event(
    Nip01Event event,
    String destPubKey, {
    String? id,
  }) async {
    return await Nip17.encode(event, destPubKey, this);
  }

  @override
  bool canSign() {
    return Helpers.isNotBlank(privateKey);
  }

  @override
  bool isGuest() {
    return !Helpers.isNotBlank(privateKey);
  }

  String? getPrivateKey() {
    return privateKey;
  }
}
