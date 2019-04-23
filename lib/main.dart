import 'package:flutter/material.dart';
import 'package:omniroute/upcomming_travel.dart';

void main() => runApp(MyApp());

AppBar mainAppBar = AppBar(
  title: Text('Omniroute'),
  elevation: 2.0,
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.grey[200],
        canvasColor: Colors.grey[200],
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          elevation: 0.0,
        ),
        primarySwatch: Colors.brown,
      ),
      home: LoginPage(),
    );
  }
}


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar,
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Text(
              'Omniroute',
              style: Theme.of(context).textTheme.display2
            ),
            SizedBox(height: 20.0,),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Username'
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Password'
              ),
            ),
            SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return UpcommingTravelPage();
                  }
                ));
              },
              child: Text('Login'),
            )
          ],
        )
      ),
    );
  }
}