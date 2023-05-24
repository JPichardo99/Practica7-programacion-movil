import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialtec/Screens/ApiPopular/actor_card_info.dart';
import 'package:socialtec/database/database_helper.dart';
import 'package:socialtec/models/actor_model.dart';
import 'package:socialtec/models/popular_model.dart';
import 'package:socialtec/network/api_popular.dart';
import 'package:socialtec/provider/flags_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  final PopularModel popularModel;

  MovieDetailScreen({Key? key, required this.popularModel}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  ApiPopular apiPopular = ApiPopular();

  @override
  Widget build(BuildContext context) {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    FlagsProvider flag = Provider.of<FlagsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.popularModel.title!),
        actions: [
          FutureBuilder(
            future: databaseHelper.searchPopular(widget.popularModel.id!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                  icon: Icon(Icons.favorite),
                  color: snapshot.data != true ? Colors.white : Colors.red,
                  onPressed: () {
                    if (snapshot.data != true) {
                      databaseHelper
                          .INSERT('tblPopularFav', widget.popularModel.toMap())
                          .then((value) {
                        var msg = value > 0
                            ? 'Pelicula agregada a favoritos'
                            : 'Ocurrio un error';
                        var snackBar = SnackBar(content: Text(msg));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        setState(() {
                          flag.getFlagListPost();
                        });
                      });
                    } else {
                      databaseHelper
                          .DELETE(
                              'tblPopularFav', widget.popularModel.id!, 'id')
                          .then((value) {
                        var msg = value > 0
                            ? 'Pelicula eliminada de favoritos'
                            : 'Ocurrio un error';
                        var snackBar = SnackBar(content: Text(msg));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        setState(() {
                          flag.getFlagListPost();
                        });
                      });
                    }
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.4,
              child: Stack(
                children: [
                  Container(
                    height: screenHeight * 0.4,
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500/' +
                          widget.popularModel.posterPath!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  FutureBuilder(
                    future: apiPopular.getVideo(widget.popularModel.id!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Positioned.fill(
                          child: YoutubePlayer(
                            controller: YoutubePlayerController(
                              initialVideoId: snapshot.data.toString(),
                              flags: YoutubePlayerFlags(
                                autoPlay: true,
                                mute: false,
                                controlsVisibleAtStart: true,
                              ),
                            ),
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.red,
                          ),
                        );
                      } else {
                        return Positioned.fill(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Sinopsis',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.popularModel.overview!,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Actores',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  FutureBuilder<List<ActorModel>?>(
                    future: apiPopular.getAllAuthors(widget.popularModel),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return SizedBox(
                          height: screenHeight * 0.2,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              ActorModel actor = snapshot.data![index];
                              return ActorCard(
                                name: actor.name!,
                                photoUrl:
                                    'https://image.tmdb.org/t/p/original${actor.profilePath}',
                              );
                            },
                          ),
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
      ),
    );
  }
}
