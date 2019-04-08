import 'package:flutter/material.dart';

class Shopping extends StatelessWidget {

  Shopping();

  final ShopItems=[Items("Hair Cream", "Smell good and last long", "\$25" , "https://cdn.shopify.com/s/files/1/0274/1389/products/suavecito-hair-cream-side.jpg?v=1546632908"),
                   Items("Shampoo", "Best seller", "\$30", "https://cdn.shopify.com/s/files/1/1771/6311/products/lemongrass-tea-shampoo_1024x1024.jpg?v=1513860274")];

  Widget _dialogbuilder(BuildContext context, Items shopitem)
  {
    return SimpleDialog(children: <Widget>[Image.network(shopitem.itemURL, fit: BoxFit.fill),
                        Padding(padding: const EdgeInsets.only(left: 16.0), child: Column(children: <Widget>[Text(shopitem.price), Text(shopitem.description)])),
                        SizedBox(height: 16.0),
                        Wrap( children: <Widget>[RaisedButton(onPressed: (){}, child: const Text("PURCHASE"), color: Colors.red, textColor: Colors.white)], alignment: WrapAlignment.center)]);
  }

  Widget _listItembuilder(BuildContext context, int index)
  {
    return GestureDetector(onTap: () => showDialog(context:context, builder: (context) => _dialogbuilder(context, ShopItems[index]) ),
                            child: Container(padding: const EdgeInsets.only(left: 16.0), alignment: Alignment.centerLeft,
                            child:Text(ShopItems[index].name, style: Theme.of(context).textTheme.headline)));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: ShopItems.length, itemExtent: 60.0, itemBuilder: _listItembuilder,);
  }
}

class Items{
  const Items(this.name, this.description, this.price, this.itemURL);

  final String name;
  final String description;
  final String price;
  final String itemURL;

}