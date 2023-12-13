import 'package:flutter/material.dart';
import 'package:pmsn20232/models/peli/popular_model.dart';
import 'package:pmsn20232/network/peli/api_popular.dart';
import 'package:pmsn20232/provider/test_provider.dart';
import 'package:pmsn20232/widgets/peli/item_popular.dart';
import 'package:pmsn20232/database/peli/database_helper.dart';
import 'package:pmsn20232/screens/peli/movie_details_screen.dart';
import 'package:provider/provider.dart';

class MovieListVideos extends StatefulWidget {
  const MovieListVideos({super.key});

  @override
  State<MovieListVideos> createState() => _MovieListVideosState();
}

class _MovieListVideosState extends State<MovieListVideos> {
  ApiPopular? apiPopular;
  bool isFavoriteView = false;
  DatabaseHelper? database;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiPopular = ApiPopular();
    database = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    TestProvider flag = Provider.of<TestProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Peliculas Populares'),
        actions: [
          IconButton(
            icon: isFavoriteView != true
                ? Icon(Icons.star)
                : Icon(Icons.list_alt),
            onPressed: () {
              setState(() {
                isFavoriteView = !isFavoriteView;
              });
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: flag.getflagListPost() == true
              ? isFavoriteView
                  ? database!.getAllPopular()
                  : apiPopular!.getAllPopular()
              : isFavoriteView
                  ? database!.getAllPopular()
                  : apiPopular!.getAllPopular(),
          builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                padding: EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .8,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: snapshot.data != null ? snapshot.data!.length : 0,
                itemBuilder: (context, index) {
                  PopularModel popularModel = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => MovieDetailScreen(
                            popularModel: snapshot.data![index],
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: snapshot.data![index].id!,
                      child: ItemPopular(popularModel: snapshot.data![index]),
                    ),
                  );
                  //return ItemPopular(popularModel: snapshot.data![index]);
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('OCURRIO UN ERROR' + snapshot.error.toString()),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
