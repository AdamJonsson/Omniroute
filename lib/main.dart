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
        primarySwatch: Colors.teal,
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
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15.0),
          width: 250.0,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  'Omniroute',
                  style: Theme.of(context).textTheme.display2.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold,)
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username'
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true
                ),
                SizedBox(height: 20.0,),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return UpcommingTravelPage();
                        }
                      ));
                    },
                    child: Text('Login', style: TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(height: 5.0,),
                Text('Forgot the password?'),
              ],
            ),
          )
        ),
      ),
    );
  }
}