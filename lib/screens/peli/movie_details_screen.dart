import 'package:flutter/material.dart';
import 'package:pmsn20232/models/peli/actor_model.dart';
import 'package:pmsn20232/models/peli/popular_model.dart';
import 'package:pmsn20232/network/peli/api_popular.dart';
import 'package:pmsn20232/widgets/peli/actor_card_info.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class MovieDetailScreen extends StatefulWidget {
  

  final PopularModel popularModel;
  MovieDetailScreen({Key? key, required this.popularModel}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  ApiPopular apiPopular = ApiPopular();
  bool showHorizontalList = true; 
  late PopularModel _currentPopularModel;
  @override
  void initState() {
    super.initState();
    _currentPopularModel = widget.popularModel;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(_currentPopularModel.title!),
        
      ),
      body: Hero(
        tag: _currentPopularModel.id!,
        child: 
          _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://image.tmdb.org/t/p/w500/' +
                      _currentPopularModel.backdropPath!,
                ),
                fit: BoxFit.fill,
                opacity: 0.5,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.all(5)),
                Text(
                  _currentPopularModel.title!,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      initialRating: _currentPopularModel.voteAverage! / 2, // Convertir a escala de 5 estrellas
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    SizedBox(width: 10),
                    Text(
                      (_currentPopularModel.voteAverage! /2).toString() + '/5',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 230, 0),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Sinopsis',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _currentPopularModel.overview!,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 30),
                Text('Trailer',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                FutureBuilder(
                  future: apiPopular.getIdVideo(_currentPopularModel.id!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: snapshot.data.toString(),
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            mute: false,
                            controlsVisibleAtStart: true,
                          ),
                        ),
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: const Color.fromARGB(225, 54, 244, 231),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                Text(
                  'Actores',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                FutureBuilder<List<ActorModel>?>(
                  future: apiPopular.getAllAuthors(_currentPopularModel),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      List<ActorModel> actors = snapshot.data!;
                      bool showHorizontalList = true; // Controla si se debe mostrar la lista horizontal

                      return Column(
                        children: [
                          if (showHorizontalList)
                            SizedBox(
                              height: 250,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: actors.length,
                                itemBuilder: (context, index) {
                                  ActorModel actor = actors[index];
                                  return ActorCard(
                                    name: actor.name!,
                                    photoUrl: actorp(actor),
                                  );
                                },
                              ),
                            )
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  actorp(ActorModel actor2){
    if(actor2.profilePath==null){
      return 'https://pluspng.com/img-png/user-png-icon-download-icons-logos-emojis-users-2240.png';
    }else{
      return 'https://image.tmdb.org/t/p/original${actor2.profilePath}';
    }
  }
}

