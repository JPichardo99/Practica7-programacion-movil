import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialtec/database/database_helper.dart';
import 'package:socialtec/models/post_model.dart';
import 'package:socialtec/provider/flags_provider.dart';

class ItemPostWidget extends StatelessWidget {
  ItemPostWidget({super.key, this.objPostModel});
  PostModel? objPostModel;
  DatabaseHelper database = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final textUser = Text('Jesus Pichardo');
    final datePost = Text('06-03-23');
    final imgPost = Image(
      image: AssetImage('assets/fondo_itcelaya.jpeg'),
      height: 150,
    );
    final txtDescripcion = Text(objPostModel!.dsc!);
    final iconRate = Icon(Icons.star);
    FlagsProvider flag = Provider.of<FlagsProvider>(context);
    return Container(
      margin: EdgeInsets.all(20.0),
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.greenAccent, borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          Row(
            children: [textUser, datePost],
          ),
          Row(
            children: [txtDescripcion],
          ),
          Row(
            children: [
              iconRate,
              Expanded(child: Container()),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add',
                        arguments: objPostModel);
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((context) => AlertDialog(
                              title: const Text('Confirmar borrado'),
                              content: const Text('Deseas borrar el post?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      database
                                          .DELETE('tblPost',
                                              objPostModel!.idPost!, 'idPost')
                                          .then((value) =>
                                              flag.setFlagListPost());
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancelar'))
                              ],
                            )));
                  },
                  icon: const Icon(Icons.delete))
            ],
          )
        ],
      ),
    );
  }
}
