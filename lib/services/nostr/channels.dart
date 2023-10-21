import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:my_app/services/nostr/connect.dart';
import 'package:synchronized/synchronized.dart';

class ChannelItem {
  final String channelId;
  final String owner;
  final int kind;
  final String picture;
  final String name;
  final String about;
  final int datetime;

  ChannelItem(
      {required this.channelId,
      required this.owner,
      required this.kind,
      required this.picture,
      required this.name,
      required this.about,
      required this.datetime});
}

typedef RecentChannelListCallBack = void Function(
    List<ChannelItem> channelList);

final channelListLock = Lock();

Future<bool> _addOrUpdateChannel(
    List<ChannelItem> channelList, ChannelItem newItem) async {
  ChannelItem? existingItem;
  bool changed = false;

  try {
    existingItem =
        channelList.firstWhere((item) => item.channelId == newItem.channelId);
  } catch (e) {
    existingItem = null;
  }

  if (existingItem == null) {
    await channelListLock.synchronized(() async {
      channelList.add(newItem);
    });
    changed = true;
  } else {
    if (existingItem.datetime < newItem.datetime) {
      await channelListLock.synchronized(() async {
        channelList.remove(existingItem);
        channelList.add(newItem);
      });
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

  void eventCallBack(Event event, String relay) {
    ChannelMessage message = Nip28.getChannelMessage(event);
    int updatedAt = event.createdAt;
    Future<void> eventCallBackChannel(Event event, String relay) async {
      Channel channel = Nip28.getChannel(event);
      final newItem = ChannelItem(
          channelId: channel.channelId,
          owner: event.pubkey,
          kind: event.kind,
          name: channel.name,
          about: channel.about,
          picture: channel.picture.isNotEmpty
              ? channel.picture
              : 'https://api.dicebear.com/7.x/thumbs/svg?seed=${channel.name}',
          datetime: updatedAt);
      if (await _addOrUpdateChannel(channelList, newItem)) {
        channelList.sort((a, b) => b.datetime.compareTo(a.datetime));
        callback(channelList);
      }
    }

    if (!reqChannelIdList.any((e) => e == message.channelId)) {
      reqChannelIdList.add(message.channelId);
      final filters = [
        Filter(kinds: [40, 41], ids: [message.channelId], limit: 1)
      ];
      Connect.sharedInstance.addSubscription(
        filters,
        eventCallBack: eventCallBackChannel,
      );
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

final channelMessageListLock = Lock();

bool _addOrUpdateChannelMessageItem(
    List<ChannelMessageItem> list, ChannelMessageItem newItem, String relay) {
  bool updated = false;
  ChannelMessageItem? existingItem;
  try {
    existingItem = list.firstWhere((item) => item.id == newItem.id);
  } catch (e) {
    existingItem = null;
  }

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
    ChannelMessage message = Nip28.getChannelMessage(event);
    final newItem = ChannelMessageItem(
        id: event.id,
        author: event.pubkey,
        content: message.content,
        thread: message.thread,
        relays: relay,
        datetime: event.createdAt);
    await channelMessageListLock.synchronized(() async {
      if (_addOrUpdateChannelMessageItem(channelMessageList, newItem, relay)) {
        channelMessageList.sort((a, b) => a.datetime.compareTo(b.datetime));
        callback(channelMessageList);
      }
    });
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
