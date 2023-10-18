import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' as d;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/i18n/strings.g.dart';
import 'package:my_app/services/nostr/keys.dart';
import 'package:my_app/services/nostr/connect.dart';
import 'package:my_app/services/nostr/channels.dart';
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
  final _channelController = StreamController<List<iconListItem>>();

  @override
  void initState() {
    super.initState();
    fetchList();
  }

  void fetchList() async {
    fetchRecentChannelList((channelList) {
      var iconListItems = channelList.map((channelItem) {
        return iconListItem(
          channelId: channelItem.channelId,
          iconUrl: channelItem.picture,
          text: channelItem.name,
          subText: channelItem.about,
          datetime: channelItem.datetime,
        );
      }).toList();
      _channelController.add(iconListItems);
    });
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
              child: StreamBuilder<List<iconListItem>>(
                  stream: _channelController.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      final list = iconListItem(
                          channelId: "",
                          text: "",
                          subText: "",
                          iconUrl: "",
                          datetime: 0);

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
