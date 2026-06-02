import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'product_model.dart';
import 'url_util.dart';

import 'counter_logic.dart';

class DetailScreen extends StatefulWidget {
  ProductModel item;
  DetailScreen(this.item);
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    int cnt = context.watch<CounterLogic>().counter;
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(
        title: Text("${item.title}"),
        // toolbarHeight: 20,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 1000 ? (screenWidth - 1000) / 2 : 8,
      ),
      child: _buildContent(),
    );
  }

  final _urlUtil = UrlUtil();
  Widget _buildContent() {
    final item = widget.item;

    return Column(
      children: [
        _buildSlideshow(item.images[0]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            child: ListTile(
              leading: FaIcon(FontAwesomeIcons.cartShopping),
              title: Text("${item.title}"),
            ),
            // color: Colors.amber,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton.icon(
                  onPressed: () {
                    final phone = "+85514664947";
                    _urlUtil.open("tel:$phone");
                  },
                  label: Text("Contact Seller"),
                  icon: Icon(Icons.call),
                ),
                FilledButton.icon(
                  onPressed: () {
                    final map =
                        "https://www.google.com/maps/place/11%C2%B045'18.5%22N+104%C2%B054'36.8%22E/@11.7551389,104.9076419,631m";
                    _urlUtil.open(map);
                  },
                  label: Text("Location"),
                  icon: Icon(Icons.pin_drop),
                ),
              ],
            ),
            // color: Colors.amber,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            child: ListTile(
              // leading: FaIcon(FontAwesomeIcons.cartShopping),
              title: Text("${item.description}"),
              // iconColor: Colors.red,
              // selectedColor: Colors.blue,
              // textColor: Colors.green,
            ),
            // color: Colors.amber,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            child: ListTile(
              leading: FaIcon(FontAwesomeIcons.dollarSign),
              title: Text("USD ${item.price.toStringAsFixed(2)}"),
              // iconColor: Colors.red,
              // selectedColor: Colors.blue,
              // textColor: Colors.green,
            ),
            // color: Colors.amber,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            child: FilledButton(onPressed: () {}, child: Text("ADD TO CAD")),
            // color: Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildSlideshow(String images) {
    return CarouselSlider.builder(
      itemCount: 1,
      options: CarouselOptions(aspectRatio: 4 / 2, viewportFraction: 0.5),
      itemBuilder: (context, index, viewIndex) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: images,
              placeholder: (_, _) => Container(color: Colors.grey),
              errorWidget: (_, _, _) => Container(color: Colors.grey.shade800),
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
