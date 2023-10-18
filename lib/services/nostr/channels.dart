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
    Filter(kinds: [42], limit: 100)
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


// void getChannelList() async {
//   Filter.fromJson(json);
// }
