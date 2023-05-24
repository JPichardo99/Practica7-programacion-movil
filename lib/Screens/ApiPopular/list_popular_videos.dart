import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialtec/Screens/ApiPopular/movie_details.dart';
import 'package:socialtec/database/database_helper.dart';
import 'package:socialtec/models/popular_model.dart';
import 'package:socialtec/network/api_popular.dart';
import 'package:socialtec/provider/flags_provider.dart';
import 'package:socialtec/widgets/item_popular.dart';

class ListPopularVideos extends StatefulWidget {
  const ListPopularVideos({super.key});

  @override
  State<ListPopularVideos> createState() => _ListPopularVideosState();
}

class _ListPopularVideosState extends State<ListPopularVideos> {
  ApiPopular? apiPopular;
  bool isFavoriteView = false;
  DatabaseHelper? database;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
    database = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    FlagsProvider flag = Provider.of<FlagsProvider>(context);
    return Scaffold(
      appBar:
          AppBar(title: const Center(child: Text('List Popular')), actions: [
        IconButton(
          icon:
              isFavoriteView != true ? Icon(Icons.favorite) : Icon(Icons.list),
          onPressed: () {
            setState(() {
              isFavoriteView = !isFavoriteView;
            });
          },
        )
      ]),
      body: FutureBuilder(
          future: flag.getFlagListPost() == true
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
                    crossAxisCount: 3,
                    childAspectRatio: .9,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemCount: snapshot.data != null ? snapshot.data!.length : 0,
                itemBuilder: (context, index) {
                  PopularModel popularModel = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
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
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Ocurrio un error'),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
