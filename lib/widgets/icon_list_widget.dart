import 'package:flutter/material.dart';
import 'package:my_app/util/util.dart';
import 'package:my_app/widgets/image_widget.dart';

class IconListItem {
  final String id;
  final String iconUrl;
  final String text;
  final String subText;
  final int datetime;

  IconListItem(
      {required this.id,
      required this.iconUrl,
      required this.text,
      required this.subText,
      required this.datetime});
}

class IconListView extends StatefulWidget {
  final List<IconListItem> lists;
  final Function(String)? onItemTap;
  const IconListView({super.key, required this.lists, this.onItemTap});
  @override
  _IconListViewState createState() => _IconListViewState();
}

class _IconListViewState extends State<IconListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.lists.length,
      itemBuilder: (context, index) {
        if (widget.lists[index].id.isEmpty) {
          return const SizedBox.shrink();
        }
        String datetimeStr =
            unixtimeToDatetimeString(widget.lists[index].datetime);
        return Card(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: ListTile(
                  onTap: () {
                    widget.onItemTap!(widget.lists[index].id);
                  },
                  leading: AdaptiveImage(
                    imageUrl: widget.lists[index].iconUrl,
                    height: 64,
                    width: 64,
                  ),
                  title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 44,
                            width: double.infinity,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.lists[index].text,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 22.0)))),
                        SizedBox(
                            height: 32,
                            width: double.infinity,
                            child: Text(widget.lists[index].subText,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10.0),
                                textAlign: TextAlign.right)),
                        SizedBox(
                            height: 15,
                            width: double.infinity,
                            child: Text(datetimeStr,
                                style: const TextStyle(fontSize: 12.0),
                                textAlign: TextAlign.right)),
                      ]),
                )));
      },
    );
  }
}
