import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
void main() {
  runApp(MyApp4());
}

class MyApp4 extends StatefulWidget {
  const MyApp4({Key? key}) : super(key: key);

  @override
  State<MyApp4> createState() => _MyApp4State();
}

class _MyApp4State extends State<MyApp4> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage4(),
    );
  }
}
class HomePage4 extends StatefulWidget {
  const HomePage4({Key? key}) : super(key: key);

  @override
  _HomePage4State createState() => _HomePage4State();
}

class _HomePage4State extends State<HomePage4> {
  late Future<List<Photo>> lsPhoto;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lsPhoto = Photo.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: lsPhoto,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            List<Photo> data= snapshot.data;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index){
                  var photo= data[index];
                  return ListTile(
                    leading: Image.network(photo.image),
                    title: Text(photo.title),
                    trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Nhập số lượng'),
                                      content: TextFormField(),
                                      actions: [
                                        TextButton(
                                            onPressed:() => Navigator.pop(context, 'Hoàn tất'),
                                            child: Text('Hoàn tất')),
                                        TextButton(
                                            onPressed:() => Navigator.pop(context, 'Đóng'),
                                            child: Text('Đóng')),
                                      ],
                                    );
                               });
                          },
                            child: const Icon(Icons.add_shopping_cart),

                    ),
                  ],
                ),
              );
            });
          }
          else {
            return Center(child: CircularProgressIndicator(),);
          }
        },

      ),
    );
  }
}

class Photo {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Map rating;
  Photo(this.id, this.title, this.price, this.description, this.category,this.image,this.rating);
  static Future<List<Photo>> fetchData() async {
    String url = "https://fakestoreapi.com/products";
    var client = http.Client();
    var response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = response.body;
      print(result);
      var jsonData = jsonDecode(result);
      List<Photo> lsPhoto = [];
      for (var item in jsonData) {
        print(item);
        var id = item['id'];
        var title = item["title"];
        var price = item['price'];
        var description = item['description'];
        var category = item['category'];
        var image = item['image'];
        var rating = item['rating'];
        Photo p = new Photo(id, title, price, description, category, image, rating);
        print(p);
        lsPhoto.add(p);
      }
      return lsPhoto;
    } else {
      print(response.statusCode);
      throw Exception("Loi lay du lieu");
    }
  }
}
