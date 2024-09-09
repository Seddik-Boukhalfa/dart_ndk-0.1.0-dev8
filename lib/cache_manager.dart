import 'package:dart_ndk/nips/nip01/event.dart';
import 'package:dart_ndk/nips/nip02/contact_list.dart';

import 'models/relay_set.dart';
import 'models/user_relay_list.dart';
import 'nips/nip01/metadata.dart';
import 'nips/nip05/nip05.dart';

abstract class CacheManager {
  Future<void> saveEvent(Nip01Event event);
  Future<void> saveEvents(List<Nip01Event> events);
  Nip01Event? loadEvent(String id, bool r);
  List<Nip01Event> loadEvents(
      {List<String> pubKeys, List<int> kinds, String? pTag});
  Future<void> removeEvent(String id);
  Future<void> removeAllEventsByPubKey(String pubKey);
  Future<void> removeAllEvents();

  Future<void> saveUserRelayList(UserRelayList userRelayList);
  Future<void> saveUserRelayLists(List<UserRelayList> userRelayLists);
  UserRelayList? loadUserRelayList(String pubKey);
  Future<void> removeUserRelayList(String pubKey);
  Future<void> removeAllUserRelayLists();

  RelaySet? loadRelaySet(String name, String pubKey);
  Future<void> saveRelaySet(RelaySet relaySet);
  Future<void> removeRelaySet(String name, String pubKey);
  Future<void> removeAllRelaySets();

  Future<void> saveContactList(ContactList contactList);
  Future<void> saveContactLists(List<ContactList> contactLists);
  ContactList? loadContactList(String pubKey);
  Future<void> removeContactList(String pubKey);
  Future<void> removeAllContactLists();

  Future<void> saveMetadata(Metadata metadata);
  Future<void> saveMetadatas(List<Metadata> metadatas);
  Metadata? loadMetadata(String pubKey);
  List<Metadata?> loadMetadatas(List<String> pubKeys);
  List<Metadata> getAllMetadatas();
  Future<void> removeMetadata(String pubKey);
  Future<void> removeAllMetadatas();
  Iterable<Metadata> searchMetadatas(String search, int limit);

  Future<void> saveNip05(Nip05 nip05);
  Future<void> saveNip05s(List<Nip05> nip05s);
  Nip05? loadNip05(String pubKey);
  List<Nip05?> loadNip05s(List<String> pubKeys);
  Future<void> removeNip05(String pubKey);
  Future<void> removeAllNip05s();
}
