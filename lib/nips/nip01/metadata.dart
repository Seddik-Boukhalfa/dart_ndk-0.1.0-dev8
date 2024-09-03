// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:dart_ndk/nips/nip01/event.dart';
import 'package:dart_ndk/nips/nip01/helpers.dart';

class Metadata {
  static const int KIND = 0;

  late String pubKey;
  String? name;
  String? displayName;
  String? picture;
  String? banner;
  String? website;
  String? about;
  String? nip05;
  String? lud16;
  String? lud06;
  int? updatedAt;
  int? refreshedTimestamp;
  bool? isDeleted;

  Metadata({
    this.pubKey = "",
    this.name,
    this.displayName,
    this.picture,
    this.banner,
    this.website,
    this.about,
    this.nip05,
    this.lud16,
    this.lud06,
    this.updatedAt,
    this.refreshedTimestamp,
    this.isDeleted,
  });

  Metadata.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    displayName = json['display_name'];
    picture = json['picture'];
    banner = json['banner'];
    website = json['website'];
    about = json['about'];
    try {
      nip05 = json['nip05'];
    } catch (e) {
      // sometimes people put maps in here
    }
    lud16 = json['lud16'];
    lud06 = json['lud06'];
    isDeleted = json['is_deleted'];
  }

  String? get cleanNip05 {
    if (nip05 != null) {
      if (nip05!.startsWith("_@")) {
        return nip05!.trim().toLowerCase().replaceAll("_@", "@");
      }
      return nip05!.trim().toLowerCase();
    }
    return null;
  }

  Map<String, dynamic> toFullJson() {
    var data = toJson();
    data['pub_key'] = pubKey;

    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['display_name'] = displayName;
    data['picture'] = picture;
    data['banner'] = banner;
    data['website'] = website;
    data['about'] = about;
    data['nip05'] = nip05;
    data['lud16'] = lud16;
    data['lud06'] = lud06;
    data['is_deleted'] = isDeleted;

    return data;
  }

  static Metadata fromEvent(Nip01Event event) {
    Metadata metadata = Metadata();

    if (Helpers.isNotBlank(event.content)) {
      Map<String, dynamic> json = jsonDecode(event.content);
      metadata = Metadata.fromJson(json);
    }

    metadata.pubKey = event.pubKey;
    metadata.updatedAt = event.createdAt;

    return metadata;
  }

  Nip01Event toEvent() {
    return Nip01Event(
      pubKey: pubKey,
      content: jsonEncode(toJson()),
      kind: KIND,
      tags: [],
      createdAt: updatedAt ?? 0,
    );
  }

  String getName() {
    if (displayName != null && Helpers.isNotBlank(displayName)) {
      return displayName!;
    }
    if (name != null && Helpers.isNotBlank(name)) {
      return name!;
    }
    return pubKey;
  }

  bool isMetadataDeleted() {
    return isDeleted != null && isDeleted!;
  }

  bool matchesSearch(String str) {
    str = str.trim().toLowerCase();
    String d = displayName != null ? displayName!.toLowerCase() : "";
    String n = name != null ? name!.toLowerCase() : "";
    String str2 = " $str";
    return d.startsWith(str) ||
        d.contains(str2) ||
        n.startsWith(str) ||
        n.contains(str2);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Metadata &&
          runtimeType == other.runtimeType &&
          pubKey == other.pubKey;

  @override
  int get hashCode => pubKey.hashCode;

  Metadata copyWith({
    String? pubKey,
    String? name,
    String? displayName,
    String? picture,
    String? banner,
    String? website,
    String? about,
    String? nip05,
    String? lud16,
    String? lud06,
    int? updatedAt,
    bool? isDeleted,
    int? refreshedTimestamp,
  }) {
    return Metadata(
      pubKey: pubKey ?? this.pubKey,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      picture: picture ?? this.picture,
      banner: banner ?? this.banner,
      website: website ?? this.website,
      about: about ?? this.about,
      nip05: nip05 ?? this.nip05,
      lud16: lud16 ?? this.lud16,
      lud06: lud06 ?? this.lud06,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      refreshedTimestamp: refreshedTimestamp ?? this.refreshedTimestamp,
    );
  }
}
