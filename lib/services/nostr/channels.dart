import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:my_app/services/nostr/connect.dart';
import 'package:synchronized/synchronized.dart';
import 'package:collection/collection.dart';
import 'package:mutex/mutex.dart';

class ChannelItem {
  final String channelId;
  final String owner;
  final int kind;
  final String picture;
  final String name;
  final String about;
  final int datetime;
  final int createdTime;

  ChannelItem(
      {required this.channelId,
      required this.owner,
      required this.kind,
      required this.picture,
      required this.name,
      required this.about,
      required this.datetime,
      required this.createdTime});
}

String tagsToChannelId(List<List<String>> tags) {
  for (var tag in tags) {
    if (tag[0] == "e") return tag[1];
  }
  return '';
}

Thread fromTags(List<List<String>> tags) {
  ETags root = ETags('', '', '');
  List<ETags> replys = [];
  List<PTags> ptags = [];
  for (var tag in tags) {
    if (tag[0] == "p") ptags.add(PTags(tag[1], tag.length > 2 ? tag[2] : ''));
    if (tag[0] == "e") {
      if (tag.length > 3 && tag[3] == 'root') {
        root = ETags(tag[1], tag[2], tag[3]);
      } else if (tag.length > 3 && tag[3] == 'reply') {
        replys.add(ETags(tag[1], tag[2], tag[3]));
      }
    }
  }
  return Thread(root, replys, ptags);
}

Channel getChannel(Event event) {
  Map content = jsonDecode(event.content);
  String picture = "";
  String about = "";
  if (content.containsKey("picture")) {
    picture = content["picture"];
  }
  if (content.containsKey("about")) {
    about = content["about"];
  }

  List<String> badges =
      content.containsKey("badges") ? jsonDecode(content["badges"]) : [];
  if (event.kind == 40) {
    // create channel
    return Channel(
        event.id, content["name"], about, picture, event.pubkey, badges);
  } else if (event.kind == 41) {
    // set channel metadata
    String channelId = tagsToChannelId(event.tags);
    return Channel(
        channelId, content["name"], about, picture, event.pubkey, badges);
  }
  throw Exception("${event.kind} is not nip40 compatible");
}

ChannelMessage getChannelMessage(Event event) {
  if (event.kind == 42) {
    var content = event.content;
    Thread thread = fromTags(event.tags);
    String channelId = thread.root.eventId;
    return ChannelMessage(
        channelId, event.pubkey, content, thread, event.createdAt);
  }
  throw Exception("${event.kind} is not nip42 compatible");
}

typedef RecentChannelListCallBack = void Function(
    List<ChannelItem> channelList);

final channelListMutex = Mutex();

bool _addOrUpdateChannel(List<ChannelItem> channelList, ChannelItem newItem) {
  ChannelItem? existingItem;
  bool changed = false;

  existingItem = channelList.firstWhereOrNull((ChannelItem item) {
    return item.channelId == newItem.channelId;
  });

  if (existingItem == null) {
    channelList.add(newItem);
    changed = true;
  } else {
    if (existingItem.createdTime < newItem.createdTime) {
      channelList.remove(existingItem);
      channelList.add(newItem);
      changed = true;
    }
  }
  return changed;
}

void fetchRecentChannelList(RecentChannelListCallBack callback) async {
  var channelList = <ChannelItem>[];
  var reqChannelIdList = <String>[];
  final filters = [
    Filter(kinds: [42], limit: 200)
  ];

  Future<void> eventCallBack(Event event, String relay) async {
    ChannelMessage message = getChannelMessage(event);
    int updatedAt = event.createdAt;
    bool wait = false;
    Future<void> eventCallBackChannel(Event event, String relay) async {
      Channel channel = getChannel(event);
      final newItem = ChannelItem(
          channelId: channel.channelId,
          owner: event.pubkey,
          kind: event.kind,
          name: channel.name,
          about: channel.about,
          picture: channel.picture.isNotEmpty
              ? channel.picture
              : 'https://api.dicebear.com/7.x/thumbs/svg?seed=${channel.name}',
          createdTime: event.createdAt,
          datetime: updatedAt);
      wait = false;
      await channelListMutex.acquire();
      try {
        if (_addOrUpdateChannel(channelList, newItem)) {
          channelList.sort((a, b) => b.datetime.compareTo(a.datetime));
        }
      } finally {
        channelListMutex.release();
      }
      callback(channelList);
    }

    if (!reqChannelIdList.any((e) => e == message.channelId)) {
      reqChannelIdList.add(message.channelId);
      final filters = [
        Filter(kinds: [40], ids: [message.channelId], limit: 1),
        Filter(kinds: [41], e: [message.channelId], limit: 1),
      ];
      wait = true;
      Connect.sharedInstance.addSubscription(
        filters,
        eventCallBack: eventCallBackChannel,
      );
      while (wait) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }
  }

  Connect.sharedInstance.addSubscription(
    filters,
    eventCallBack: eventCallBack,
  );
}

class ChannelMessageItem {
  final String id;
  final String author;
  final String content;
  final Thread thread;
  final String relays;
  final int datetime;

  ChannelMessageItem(
      {required this.id,
      required this.author,
      required this.content,
      required this.thread,
      required this.relays,
      required this.datetime});
}

typedef RecentChanneMessageCallBack = void Function(
    List<ChannelMessageItem> channelMessageList);

final channelMessageListMutex = Mutex();

bool _addOrUpdateChannelMessageItem(
    List<ChannelMessageItem> list, ChannelMessageItem newItem, String relay) {
  bool updated = false;
  ChannelMessageItem? existingItem;
  existingItem = list.firstWhereOrNull((item) => item.id == newItem.id);

  if (existingItem != null) {
    if (!existingItem.relays.split(',').contains(relay)) {
      var updatedRelays = '${existingItem.relays},$relay';
      list.remove(existingItem);
      list.add(ChannelMessageItem(
        id: existingItem.id,
        author: existingItem.author,
        content: existingItem.content,
        thread: existingItem.thread,
        relays: updatedRelays,
        datetime: existingItem.datetime,
      ));
      updated = true;
    }
  } else {
    list.add(newItem);
    updated = true;
  }
  return updated;
}

void fetchRecentChannelMessages(
    String channelId, RecentChanneMessageCallBack callback) async {
  var channelMessageList = <ChannelMessageItem>[];

  Future<void> eventCallBack(Event event, String relay) async {
    ChannelMessage message = getChannelMessage(event);
    final newItem = ChannelMessageItem(
        id: event.id,
        author: event.pubkey,
        content: message.content,
        thread: message.thread,
        relays: relay,
        datetime: event.createdAt);
    await channelMessageListMutex.acquire();
    try {
      if (_addOrUpdateChannelMessageItem(channelMessageList, newItem, relay)) {
        channelMessageList.sort((a, b) => a.datetime.compareTo(b.datetime));
        callback(channelMessageList);
      }
    } finally {
      channelMessageListMutex.release();
    }
  }

  final filters = [
    Filter(
        e: [channelId],
        kinds: [42],
        until: DateTime.now().toUtc().millisecondsSinceEpoch * 1000,
        limit: 100)
  ];

  Connect.sharedInstance.addSubscription(filters, eventCallBack: eventCallBack);
}
