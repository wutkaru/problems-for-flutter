import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'init.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Profile',
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PersonPage(),
    );
  }
}


class PersonPage extends StatefulWidget {
  const PersonPage({Key key}) : super(key: key);
  
  _PersonPageStateState createState() => _PersonPageStateState();
}

class _PersonPageStateState extends State<PersonPage> with SingleTickerProviderStateMixin {
  List _userList = [];

  @override
  void initState() {
    super.initState();

    _userList = CONSTANTS.userList;
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setString('userList', json.encode(CONSTANTS.userList));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Person'),
      ),
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var item in _userList ) _buildCard(context, item["id"], item["image"], item["name"], item["email"], item["birthDate"], item["address"])
              ]
            )
          )
        )
      )
    );
  }

  Widget _buildCard(BuildContext context, int id, String image, String name, String email, String birthDate, String address) {
    return InkWell(
      onTap: () async { 
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditProfilePage(id: id, image: image, name: name, email: email, birthDate: birthDate, address: address)),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _userList = json.decode(prefs.getString('userList'));
        setState(() {
          
        });
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  radius: 48,
                  child: ClipOval(child: Image.asset(image)),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(name),
                    Text(email),
                  ],
                ),
                subtitle: Text(address),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final int id;
  final String image;
  final String name; 
  final String email;
  final String birthDate;
  final String address;
  const EditProfilePage({Key key, this.id, this.image, this.name, this.email, this.birthDate, this.address}) : super(key: key);

  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> with SingleTickerProviderStateMixin {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _emailController.text = widget.email;
    _birthDateController.text = widget.birthDate;
    _addressController.text = widget.address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Profile'),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () async { 
              bool inValid = _nameController.text.isEmpty || _emailController.text.isEmpty || _birthDateController.text.isEmpty || _addressController.text.isEmpty;
             
              if (!inValid) { 
                SharedPreferences prefs = await SharedPreferences.getInstance();
                List userList = json.decode(prefs.getString('userList'));
                int index = userList.indexWhere((user) => user["id"] == widget.id);
                userList[index] = {
                  ...userList[index],
                  "name": _nameController.text,
                  "email": _emailController.text,
                  "birthDate": _birthDateController.text,
                  "address": _addressController.text,
                };
                await prefs.setString('userList', json.encode(userList));
                Navigator.pop(context);
              } else {
                setState(() {});
              }
            },
            child: Text("Save"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [ 
                  CircleAvatar(
                    radius: 48,
                    child: ClipOval(child: Image.asset(widget.image)),
                  ),
                  Row(
                    children: [ 
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Name'),
                      )
                    ]
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: TextField(
                      controller: _nameController..text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Name',
                        errorText: _nameController.text.length == 0 ? 'Name Can\'t Be Empty' : null,
                      ),
                    ),
                  ),
                  Row(
                    children: [ 
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('E-mail'),
                      )
                    ]
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: TextField(
                      controller: _emailController..text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'E-mail',
                        errorText: _emailController.text.length == 0 ? 'E-mail Can\'t Be Empty' : null,
                      ),
                    ),
                  ),
                  Row(
                    children: [ 
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Birth Date'),
                      )
                    ]
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: TextField(
                      controller: _birthDateController..text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Birth Date',
                        errorText: _birthDateController.text.length == 0 ? 'Birth Date Can\'t Be Empty' : null,
                      ),
                    ),
                  ),
                  Row(
                    children: [ 
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Address'),
                      )
                    ]
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: TextField(
                      controller: _addressController..text,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Address',
                        errorText: _addressController.text.length == 0 ? 'Address Date Can\'t Be Empty' : null,
                      ),
                    ),
                  ),
                ],
              )
            )
          )
        )
      )
    );
  }
}

