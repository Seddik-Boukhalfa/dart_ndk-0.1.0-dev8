import 'package:dart_ndk/nips/nip01/event.dart';

abstract class EventSigner {
  Future<void> sign(Nip01Event event);

  String getPublicKey();

  Future<String?> decrypt04(String msg, String destPubKey, {String? id});

  Future<String?> encrypt04(String msg, String destPubKey, {String? id});

  Future<String?> decrypt44(String msg, String destPubKey, {String? id});

  Future<String?> encrypt44(String msg, String destPubKey, {String? id});

  Future<Nip01Event?> decrypt44Event(
    Nip01Event event, {
    String? id,
  });

  Future<Nip01Event?> encrypt44Event(
    Nip01Event event,
    String destPubKey, {
    String? id,
  });

  bool canSign();
}
