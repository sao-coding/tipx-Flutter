import 'package:flutter/material.dart';
import 'package:tipx/main.dart';
import 'package:tipx/models/post_card_type.dart';
import 'package:tipx/ui/home/post.dart';
import 'dart:developer' as developer;

class Card extends StatefulWidget {
  final PostCardType post;
  const Card({super.key, required this.post});

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Post(widget.post.id ?? ''),
            ),
          );
          developer.log('click card: ${widget.post.title}',
              name: '_CardState.build');
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
            padding: const EdgeInsets.all(8.0),
            //全部文字大小 16px
            // 高度 144px
            height: 144,
            // 點擊卡片後 有 ripple effect 特效
            child: Stack(children: <Widget>[
              Column(
                // 向左對齊
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '${widget.post.category}',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      '${widget.post.title}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      children: <Widget>[
                        // icon 大小 24px
                        const Icon(Icons.event_outlined, size: 20),
                        const SizedBox(width: 4),
                        Text('${widget.post.date}'),
                        const SizedBox(width: 4),
                        const Icon(Icons.event_busy_outlined, size: 20),
                        const SizedBox(width: 4),
                        Text('${widget.post.deadline}'),
                      ],
                    ),
                  ),
                ],
              ),
              // 置頂 icon 傾斜 45 度
              // 背景 icon 顏色為 white 圓形
              // widget.post.sticky 若為 true 顯示置頂 icon
              if (widget.post.sticky == true)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    // color: Colors.black,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Transform.rotate(
                      angle: 30 * 3.1415926 / 180,
                      child: const Icon(
                        Icons.push_pin,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 2.0),
                  alignment: Alignment.center,
                  // color: Colors.black,
                  decoration: BoxDecoration(
                    // amber 100
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.post.unit}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ])));
  }
}
