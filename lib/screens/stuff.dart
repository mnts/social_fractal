import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import 'package:flutter/material.dart';
import 'package:fractal_wysiwyg/slides/mslide.dart';
import 'package:matrix/matrix.dart';

class StuffScreen extends StatefulWidget {
  const StuffScreen({super.key});

  @override
  State<StuffScreen> createState() => _StuffScreenState();
}

class _StuffScreenState extends State<StuffScreen>
    with AutomaticKeepAliveClientMixin<StuffScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    client.getRoomByAlias('');
    client.search(
      Categories(
        roomEvents: RoomEventsCriteria(
          filter: SearchFilter(),
          searchTerm: 'domain.name',
        ),
      ),
    );
    return StreamBuilder<Object?>(
      stream: Matrix.of(context).onShareContentChanged.stream,
      builder: (_, __) {
        final list = client.rooms.where((el) => el.avatar != null);

        final mq = MediaQuery.of(context);
        final theme = Theme.of(context);

        return DefaultTabController(
          length: list.length,
          child: Stack(
            children: [
              TabBarView(
                //physics: BouncingScrollPhysics(),
                children: [
                  for (final item in list)
                    ReSlide(
                      saver: (data) {
                        item.client.setRoomStateWithKey(
                            item.id, 'm.room.text', '', {'text': data});
                      },
                      loader: () async => (await item.client
                          .getRoomStateWithKey(
                              item.id, 'm.room.text', ''))['text'],
                      background: MxcImage(
                        key: Key(item.avatar.toString()),
                        uri: item.avatar,
                        fit: BoxFit.cover,
                        isThumbnail: false,
                        width: mq.size.width,
                        height: mq.size.height,
                        placeholder: (_) => Text(item.avatar.toString()),
                        cacheKey: item.avatar.toString(),
                      ),
                    ),
                ],
              ),
              Positioned(
                bottom: 2,
                height: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.canvasColor.withAlpha(190),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      isScrollable: true,
                      tabs: [
                        for (final item in list)
                          Tab(
                            text: item.displayname,
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
