import 'package:flutter/material.dart';
import 'package:pmsn20232/provider/test_provider.dart';
import 'package:provider/provider.dart';
import 'package:pmsn20232/models/peli/popular_model.dart';
import 'package:pmsn20232/database/peli/database_helper.dart';

class ItemPopular extends StatefulWidget {
  ItemPopular({super.key, required this.popularModel});
  PopularModel popularModel;

  @override
  State<ItemPopular> createState() => _ItemPopularState();
}

class _ItemPopularState extends State<ItemPopular> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    TestProvider flag = Provider.of<TestProvider>(context);
    return Stack(
      children: [
        Container(
          /*decoration: BoxDecoration(
            ,
            shape: BoxShape.circle,
            border: Border.all(color: Color.fromARGB(255, 106, 255, 0)),
          ),*/
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FadeInImage(
              fit: BoxFit.fill,
              placeholder: AssetImage('assets/loading.gif'),
              image: NetworkImage('https://image.tmdb.org/t/p/w500/' +
                  widget.popularModel.posterPath.toString()),
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          right: 20,
          child: FutureBuilder(
              future: databaseHelper.searchPopular(widget.popularModel.id!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return IconButton(
                    icon: Icon(Icons.star),
                    color: snapshot.data != true ? const Color.fromARGB(255, 106, 106, 106) : Colors.yellow,
                    onPressed: () {
                      if (snapshot.data != true) {
                        databaseHelper
                            .INSERTAR(
                                'tblPopularFav', widget.popularModel.toMap())
                            .then((value) => flag.setflagListPost());
                      } else {
                        databaseHelper
                            .ELIMINAR(
                                'tblPopularFav', widget.popularModel.id!, 'id')
                            .then((value) => flag.setflagListPost());
                      }
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ],
    );
  }
}
