import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' as d;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/i18n/strings.g.dart';
import 'package:my_app/services/nostr/keys.dart';
import 'package:my_app/services/nostr/connect.dart';
import 'package:my_app/db/db.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:provider/provider.dart';
import 'package:my_app/widgets/icon_list_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _channelController = StreamController<List<ListRow>>();

  @override
  void initState() {
    super.initState();
    fetchList();
  }

  Future<List<ListRow>> fetchList() async {
    var channel_list = <ListRow>[];
    final filters = [
      Filter(kinds: [42], limit: 100)
    ];

    void eventCallBack(Event event, String relay) {
      ChannelMessage message = Nip28.getChannelMessage(event);
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(event.createdAt * 1000);
      String updatedAt =
          "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";

      void eventCallBackChannel(Event event, String relay) {
        Channel channel = Nip28.getChannel(event);
        if (!channel_list.any((e) => e.channelId == channel.channelId)) {
          channel_list.add(ListRow(
              channelId: channel.channelId,
              text: channel.name,
              subText: channel.about,
              iconUrl: channel.picture,
              datetime: updatedAt));
          _channelController.add(channel_list);
        }
      }

      final filters = [
        Filter(kinds: [40, 41], ids: [message.channelId], limit: 1)
      ];
      Connect.sharedInstance.addSubscription(
        filters,
        eventCallBack: eventCallBackChannel,
      );
    }

    Connect.sharedInstance.addSubscription(
      filters,
      eventCallBack: eventCallBack,
    );

    return channel_list;
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context, listen: false);
    return Scaffold(
        body: Column(children: [
      Expanded(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: StreamBuilder<List<ListRow>>(
                  stream: _channelController.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      final list = ListRow(
                          channelId: "",
                          text: "",
                          subText: "",
                          iconUrl: "",
                          datetime: "");

                      return IconListView(lists: [list]);
                    }
                    return IconListView(lists: snapshot.data!);
                  }))),
      TextButton(
        onPressed: () async {
          final result = await compute(generateWrapper, null);
          if (kDebugMode) {
            final enPrivkey = result.enPrivkey;
            print(enPrivkey);
            print(getEncodedPubkey(result.user.public));
            print(getEncodedPrivkey(result.user.private));
          }
          final String avatar_url =
              'https://api.dicebear.com/7.x/thumbs/svg?seed=${result.user.public}';
          Map map = {
            'name': t.AnonymousNamePrefix,
            'display_name': t.AnonymousDisplayNamePrefix,
            'about': '',
            'picture': avatar_url,
          };
          Event event = Nip1.setMetadata(jsonEncode(map), result.user.private);
          Connect.sharedInstance.sendEvent(event);
          Event channelMessage = Nip28.sendChannelMessage(
              "cd5db895dbe1380bbdf4dd3dd5adc37af1b489a1bcc00479cc0ba0e7f98a0c49",
              "hello!",
              null,
              null,
              result.user.private);
          Connect.sharedInstance.sendEvent(channelMessage);
          final newUser = UsersCompanion(
            pubkeyHex: d.Value(result.user.public),
            privkeyHex: d.Value(result.enPrivkey),
            password: d.Value(result.password),
            name: d.Value(t.AnonymousNamePrefix),
            displayName: d.Value(t.AnonymousDisplayNamePrefix),
            bio: const d.Value(''),
            avatar: d.Value(avatar_url),
            kind0: d.Value(event.content),
            updateAt: d.Value(DateTime.now()),
          );
          await database.userDao.insertUser(newUser);
        },
        child: const Text("generate"),
      )
    ]));
    // ))));
  }
}
