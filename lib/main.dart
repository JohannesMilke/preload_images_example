import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:preload_images_example/data.dart';
import 'package:preload_images_example/model/fruit.dart';
import 'package:preload_images_example/utils.dart';
import 'package:preload_images_example/widget/skeleton_container.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = 'Preload Images Into Cache';

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  Future loadData() async {
    setState(() {
      loading = true;
    });

    await Future.wait(fruits
        .map((fruit) => Utils.cacheImage(context, fruit.urlImage))
        .toList());

    // await Future.delayed(Duration(seconds: 1), () {});

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: loadData,
            ),
          ],
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(12),
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) => Divider(),
          itemCount: fruits.length,
          itemBuilder: (BuildContext context, int index) {
            final fruit = fruits[index];

            return loading ? buildSkeleton(context) : buildResult(fruit);
          },
        ),
      );

  Widget buildSkeleton(BuildContext context) => Row(
        children: <Widget>[
          SkeletonContainer.circular(
            width: 70,
            height: 70,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SkeletonContainer.rounded(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 25,
              ),
              const SizedBox(height: 8),
              SkeletonContainer.rounded(
                width: 60,
                height: 13,
              ),
            ],
          ),
        ],
      );

  Widget buildResult(Fruit fruit) => Row(
        children: <Widget>[
          Container(
            child: CircleAvatar(
              backgroundImage: AdvancedNetworkImage(
                fruit.urlImage,
                useDiskCache: true,
              ),
              radius: 35,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                fruit.name,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 8),
              Text(
                fruit.description,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      );
}
