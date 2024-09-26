import 'package:dart_ndk/nips/nip02/contact_list.dart';
import 'package:isar/isar.dart';

part 'db_contact_list.g.dart';

@Collection(inheritance: true)
class DbContactList extends ContactList {
  DbContactList({required super.pubKey, required super.contacts});

  String get id => pubKey;

  static DbContactList fromContactList(ContactList contactList) {
    DbContactList dbContactList = DbContactList(
      pubKey: contactList.pubKey,
      contacts: contactList.contacts,
    );
    dbContactList.createdAt = contactList.createdAt;
    dbContactList.loadedTimestamp = contactList.loadedTimestamp;
    dbContactList.sources = contactList.sources;
    dbContactList.followedCommunities = contactList.followedCommunities;
    dbContactList.followedTags = contactList.followedTags;
    dbContactList.followedEvents = contactList.followedEvents;
    dbContactList.contactRelays = contactList.contactRelays;
    dbContactList.petnames = contactList.petnames;
    return dbContactList;
  }
}
