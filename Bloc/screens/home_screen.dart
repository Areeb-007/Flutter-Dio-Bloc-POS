import 'package:bloc_pattern/bloc%20pattern/userBlocPattern.dart';
import 'package:bloc_pattern/models/User.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserBloc _userBloc = UserBloc();

  @override
  void dispose() {
    super.dispose();
    _userBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BLOC TRY',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        centerTitle: true,
        textTheme: Theme.of(context).textTheme,
      ),
      body: Center(
        child: StreamBuilder(
          stream: _userBloc.userListStream,
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            return ListView.builder(
                itemCount: !snapshot.hasData ? 0 : snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Text(snapshot.data![index].username),
                        ),
                        Container(
                          child: Text(snapshot.data![index].qualification),
                        ),
                        Container(
                          child: Text(snapshot.data![index].salary.toString()),
                        ),
                        Container(
                            child: IconButton(
                                icon: Icon(Icons.thumb_up_alt_sharp),
                                color: Colors.green,
                                onPressed: () {
                                  _userBloc.userIncrement
                                      .add(snapshot.data![index]);
                                })),
                        Container(
                            child: IconButton(
                                icon: Icon(Icons.thumb_down_alt_sharp),
                                color: Colors.red,
                                onPressed: () {
                                  _userBloc.userDecrement
                                      .add(snapshot.data![index]);
                                }))
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
