import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialtec/database/database_helper.dart';
import 'package:socialtec/models/post_model.dart';
import 'package:socialtec/provider/flags_provider.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({super.key});

  DatabaseHelper database = DatabaseHelper();
  PostModel? obPostModel;

  @override
  Widget build(BuildContext context) {
    FlagsProvider flag = Provider.of<FlagsProvider>(context);
    final txtContPost = TextEditingController();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      obPostModel = ModalRoute.of(context)!.settings.arguments as PostModel;
      txtContPost.text = obPostModel!.dsc!;
    }
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(30.0),
          padding: EdgeInsets.all(30.0),
          height: 350,
          decoration: BoxDecoration(
              color: Colors.green, border: Border.all(color: Colors.black)),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              obPostModel == null ? Text('Add Post') : Text('Update Post'),
              SizedBox(height: 15.0),
              TextFormField(
                controller: txtContPost,
                maxLines: 4,
              ),
              SizedBox(height: 15.0),
              ElevatedButton(
                  onPressed: () {
                    if (obPostModel == null) {
                      database.INSERT('tblPost', {
                        'dsc': txtContPost.text,
                        'datePost': DateTime.now().toString()
                      }).then((value) {
                        var msg =
                            value > 0 ? 'Post guardado' : 'Ocurrio un problema';
                        var snackBar = SnackBar(content: Text(msg));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    } else {
                      database
                          .UPDATE(
                              'tblPost',
                              {
                                'idPost': obPostModel!.idPost,
                                'dsc': txtContPost.text,
                                'datePost': DateTime.now().toString()
                              },
                              'idPost')
                          .then((value) {
                        var msg = value > 0
                            ? 'Post actualizado'
                            : 'Ocurrio un problema';
                        var snackBar = SnackBar(content: Text(msg));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    }
                    flag.setFlagListPost();
                  },
                  child: obPostModel == null
                      ? Text('Add Post')
                      : Text('Update Post'))
            ],
          ),
        ),
      ),
    );
  }
}
