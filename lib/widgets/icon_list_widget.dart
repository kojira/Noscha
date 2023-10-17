import 'package:flutter/material.dart';
import 'package:my_app/widgets/image_widget.dart';

class ListRow {
  final String channelId;
  final String iconUrl;
  final String text;
  final String subText;
  final String datetime;

  ListRow(
      {required this.channelId,
      required this.iconUrl,
      required this.text,
      required this.subText,
      required this.datetime});
}

class IconListView extends StatefulWidget {
  final List<ListRow> lists;
  const IconListView({super.key, required this.lists});
  @override
  _IconListViewState createState() => _IconListViewState();
}

class _IconListViewState extends State<IconListView> {
  // Future<List<ListRow>> fetchChannels() async {
  //   // await Future.delayed(Duration(seconds: 2)); // シミュレーションのための遅延
  //   return [
  //     ListRow(
  //         text: "Aliceの部屋",
  //         subText: "Alice",
  //         iconUrl: "https://api.dicebear.com/7.x/thumbs/svg?seed=alice",
  //         datetime: "2023-10-17 11:00:03"),
  //     ListRow(
  //         text: "Bob",
  //         subText: "Bobの秘密の部屋",
  //         iconUrl: "https://api.dicebear.com/7.x/thumbs/svg?seed=bob",
  //         datetime: "2023-10-17 10:32:23"),
  //     // その他のユーザー
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.lists.length,
      itemBuilder: (context, index) {
        if (widget.lists[index].channelId.isEmpty) {
          return const SizedBox.shrink();
        }
        return Card(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: ListTile(
                  leading: AdaptiveImage(
                    imageUrl: widget.lists[index].iconUrl.isNotEmpty
                        ? widget.lists[index].iconUrl
                        : 'https://api.dicebear.com/7.x/thumbs/svg?seed=${widget.lists[index].text}',
                    height: 64,
                    width: 64,
                  ),
                  title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 48,
                            width: double.infinity,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.lists[index].text,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 24.0)))),
                        SizedBox(
                            height: 30,
                            width: double.infinity,
                            child: Text(widget.lists[index].subText,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right)),
                        SizedBox(
                            height: 15,
                            width: double.infinity,
                            child: Text(widget.lists[index].datetime,
                                textAlign: TextAlign.right)),
                      ]),
                )));
      },
    );
  }
}
