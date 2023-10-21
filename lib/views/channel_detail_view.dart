import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/services/nostr/channels.dart';
import 'package:my_app/widgets/post_list_widget.dart';

class ChannelDetailView extends StatefulWidget {
  const ChannelDetailView({super.key, required this.channelId});
  final String channelId;

  @override
  _ChannelDetailViewState createState() => _ChannelDetailViewState();
}

class _ChannelDetailViewState extends State<ChannelDetailView> {
  final _streamController = StreamController<List<PostListItem>>();

  void recentChannelMessagesCallback(
      List<ChannelMessageItem> channelMessageList) {
    var postListItems = channelMessageList.map((channelItem) {
      return PostListItem(
        id: channelItem.id,
        iconUrl:
            'https://api.dicebear.com/7.x/thumbs/svg?seed=${channelItem.author}',
        name: channelItem.author,
        text: channelItem.content,
        images: "",
        datetime: channelItem.datetime,
      );
    }).toList();
    _streamController.add(postListItems);
  }

  @override
  void initState() {
    super.initState();
    fetchRecentChannelMessages(widget.channelId, recentChannelMessagesCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Channel Details')),
      body: Column(children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: StreamBuilder<List<PostListItem>>(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        final list = PostListItem(
                            id: "",
                            name: "",
                            text: "",
                            images: "",
                            iconUrl: "",
                            datetime: 0);

                        return PostListView(lists: [list]);
                      }
                      return PostListView(lists: snapshot.data!);
                    })))
      ]),
    );
  }
}
