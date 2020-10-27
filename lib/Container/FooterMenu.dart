import 'package:flutter/material.dart';
import 'package:regal_app/Screens/LoginScreen.dart';
import 'package:qr_flutter/qr_flutter.dart';




class FooterMenuController extends StatefulWidget {

  FooterMenuController({Key key, @required this.contactNumber}) : super(key: key);
 final String contactNumber;

  @override
  _FooterMenuState createState() => _FooterMenuState(contactNumber: contactNumber);

}

class _FooterMenuState extends State<FooterMenuController> {

  final String contactNumber;
  _FooterMenuState({this.contactNumber});

  Widget menu() {
    return Container(
      color: Colors.lightBlue,
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.blue,
        tabs: [
          Tab(
            text: "QR code",
            icon: Icon(Icons.call),
          ),
          Tab(
            text: "Info",
            icon: Icon(Icons.account_circle),
          ),
          Tab(
            text: "Wallet",
            icon: Icon(Icons.account_balance_wallet),
          ),
          Tab(
            text: "Setting",
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Logout"),
          content: new Text("Are you sure you want to logout?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            title: Text("Title"),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.power_settings_new), onPressed: (){
                _showDialog();
              }),
            ],

          ),
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              Container(
                color: Colors.black12,
                height: 300,
                width: 100,
                child: QrImage(
                  data: this.contactNumber == null ? '' : this.contactNumber,
                  version: QrVersions.auto,
                  size: 320,
                  gapless: false,
                  embeddedImage: AssetImage('assets/images/regal.jpg'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(1, 1),
                  ),
                )
              ),
              Container(child: Icon(Icons.account_circle)),
              Container(child: Icon(Icons.account_balance_wallet)),
              Container(child: Icon(Icons.settings)
              ),
            ],
          ),
        ),
      ),
    );
  }

}
