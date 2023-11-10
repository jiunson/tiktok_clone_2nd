import 'package:flutter/material.dart';
import 'package:tiktok_clone_2nd/constants/sizes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          // snap: true,
          // floating: true, // 스크롤UP시 타이틀이미지가 즉시 나타난다.
          stretch: true,
          pinned: true, // 배경색과 flexibleSpaceBar의 title을 보여준다.
          backgroundColor: Colors.teal,
          collapsedHeight: 80,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.blurBackground,
              StretchMode.zoomBackground,
              StretchMode.fadeTitle,
            ],
            background: Image.asset(
              "assets/images/placeholder.jpg",
              fit: BoxFit.cover,
            ),
            title: const Text("Hello!"),
          ),
        ),
        const SliverToBoxAdapter(
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red,
                radius: 20,
              )
            ],
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            childCount: 50,
            (context, index) => Container(
              color: Colors.amber[100 * (index % 9)], // 그라데이션 설정
              child: Align(
                alignment: Alignment.center,
                child: Text("Item $index"),
              ),
            ),
          ),
          itemExtent: 100, // item 높이 : 100 unit
        ),
        SliverPersistentHeader(
          delegate: CustomDelegate(),
          // floating: true, // 스크롤UP시 타이틀이미지가 즉시 나타난다.
          pinned: true, // 스크롤 시 상단에 고정.
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            childCount: 50,
            (context, index) => Container(
              color: Colors.blue[100 * (index % 9)],
              child: Align(
                alignment: Alignment.center,
                child: Text("Item $index"),
              ),
            ),
          ),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            mainAxisSpacing: Sizes.size20,
            crossAxisSpacing: Sizes.size20,
            childAspectRatio: 1,
          ),
        ),
      ],
    );
  }
}

class CustomDelegate extends SliverPersistentHeaderDelegate {
  // 화면에 보이게 될 widget을 return 한다.
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.indigo,
      child: const FractionallySizedBox(
        heightFactor: 1,
        child: Center(
          child: Text(
            "Title!!!!!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 150; // 기본 높이, 최대 높이

  @override
  double get minExtent => 80; // 아래로 스크롤 시 높이, 최저 높이,

  // flutter에게 persistent header가 보여져야 되는지 알려주는 method.
  // maxExtent, minExtent의 값을 변경하려면 true를 설정.
  // bulud에서 완전히 다른 widget tree를 return한다면 false 설정.
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
