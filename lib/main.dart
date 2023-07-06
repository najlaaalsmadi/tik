import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<List<Album>> fetchAlbum() async {
  final response =
  await http.get(Uri.parse("https://fakestoreapi.com/products"));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<Album> albums = data.map((json) => Album.fromJson(json)).toList();
    return albums;
  } else {
    throw Exception("Failed to load album");
  }
}

class Album {
  final String image;
  final int id;
  final String title;
  final double price;

  Album({
    required this.image,
    required this.id,
    required this.title,
    required this.price,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      image: json['image'],
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Album>> albumData;

  @override
  void initState() {
    super.initState();
    albumData = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fetch Data Example",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Fetch Data Example"),
        ),
        body: Center(
          child: FutureBuilder<List<Album>>(
            future: albumData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var album = snapshot.data![index];
                    return ListTile(
                      leading: Image.network(album.image),
                      title: Text(album.title),
                      subtitle: Text("Price: \$${album.price}"),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
