import 'package:flutter/material.dart';
import 'package:gegeengii_app/constants.dart';
import 'package:gegeengii_app/models/user.dart';
import 'package:gegeengii_app/providers/auth_provider.dart';
import 'package:gegeengii_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = "/register";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  PageController _pageController =
      PageController(initialPage: 0, keepPage: false);
  int currentPage = 0;

  final formKey = new GlobalKey<FormState>();
  TextEditingController _controller;
  TextEditingController _controller2;
  TextEditingController _controller3;
  TextEditingController _controller4;

  String _email;
  String _name;
  String _password;
  String _password2;

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '');
    _controller2 = TextEditingController(text: '');
    _controller3 = TextEditingController(text: '');
    _controller4 = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Бүртгэл'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/child2.png'),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Form(
                  key: formKey,
                  child: PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (value) {
                      setState(() {
                        print('value: $value');
                        currentPage = value;
                      });
                    },
                    itemCount: 3,
                    itemBuilder: (context, index) =>
                        Container(child: _buildInputContent(index: index)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputContent({int index}) {
    if (index == 0) {
      return _buildStep1();
    } else if (index == 1) {
      return _buildStep2();
    } else if (index == 2) {
      return _buildStep3();
    }
  }

  Widget _buildStep1() {
    print("inputContent: $_email");
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            controller: _controller,
            // onSaved: (value) => _email = value,
            validator: (value) {
              if (value.isEmpty || !isEmail(value)) {
                return 'Мэйл хаягаа зөв оруулна уу!';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(90),
                ),
              ),
              filled: true,
              hintText: "Мэйл хаягаа оруулна уу",
              contentPadding:
                  EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
              fillColor: Colors.white70,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                padding: EdgeInsets.only(right: 10),
                onPressed: () {
                  final form = formKey.currentState;

                  if (form.validate()) {
                    form.save();
                    _pageController.animateToPage(
                      1,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.ease,
                    );
                    print("step1 onPressed!");
                  }
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 15),
                    Text(
                      'Үргэжлүүлэх',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: kPrimaryColor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward,
                      color: kPrimaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            controller: _controller2,
            // onSaved: (value) => _name = value,
            validator: (value) {
              if (value.isEmpty) {
                return 'Та өөрийн нэрээ оруулна уу!';
              }
              if (value.length <= 1) {
                return 'Таны нэрийн урт бага байна!';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(90),
                ),
              ),
              filled: true,
              hintText: "Нэрээ бичнэ үү",
              contentPadding:
                  EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
              fillColor: Colors.white70,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, right: 5),
          child: Row(
            children: <Widget>[
              SizedBox(width: 5),
              FlatButton(
                onPressed: () {
                  _pageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.ease,
                  );
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_back,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Өмнөх",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              FlatButton(
                padding: EdgeInsets.only(right: 10),
                onPressed: () {
                  final form = formKey.currentState;

                  if (form.validate()) {
                    form.save();
                    _pageController.animateToPage(
                      2,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.ease,
                    );
                    print("step2 onPressed!");
                  }
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 15),
                    Text(
                      'Үргэжлүүлэх',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: kPrimaryColor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward,
                      color: kPrimaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            controller: _controller3,
            obscureText: true,
            // onSaved: (value) => _password = value,
            validator: (value) {
              if (value.isEmpty || value.length <= 5) {
                return 'Таны нууц үгийн урт бага байна';
              }

              if (value != _controller4.text) {
                return 'Нууц үг таарахгүй байна';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(90),
                ),
              ),
              filled: true,
              hintText: "Шинэ нууц үг оруулна уу",
              contentPadding:
                  EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
              fillColor: Colors.white70,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: TextFormField(
            controller: _controller4,
            obscureText: true,
            // onSaved: (value) => _password2 = value,
            validator: (value) {
              if (value.isEmpty || value.length <= 5) {
                return 'Таны нууц үгийн урт бага байна';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(90),
                ),
              ),
              filled: true,
              hintText: "Давтан оруулна уу",
              contentPadding:
                  EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
              fillColor: Colors.white70,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, right: 5),
          child: Row(
            children: <Widget>[
              SizedBox(width: 5),
              FlatButton(
                onPressed: () {
                  _pageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.ease,
                  );
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_back,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Өмнөх",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                textColor: Colors.white,
                color: Color(0xFF23B89B),
                onPressed: () {
                  final form = formKey.currentState;

                  if (form.validate()) {
                    form.save();

                    final Future<Map<String, dynamic>> successfullMessage =
                        auth.signup(_controller2.text, _controller.text,
                            _controller3.text);

                    successfullMessage.then((response) {
                      if (response['status']) {
                        User user = response['user'];
                        Provider.of<UserProvider>(context, listen: false)
                            .setUser(user);
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        _showErrorDialog(response);
                      }
                    });
                  }
                },
                child: Text(
                  'Бүртгэх',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    // color: kPrimaryColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }

  _showErrorDialog(Map<String, dynamic> res) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: SizedBox(
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Бүртгэхэд алдаа гарлаа',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              if (res['message']['name'] != null)
                Text(res['message']['name'][0],
                    style: TextStyle(color: Colors.red, fontSize: 13)),
              if (res['message']['email'] != null)
                Text(res['message']['email'][0],
                    style: TextStyle(color: Colors.red, fontSize: 13)),
              if (res['message']['password'] != null)
                Text(res['message']['password'][0],
                    style: TextStyle(color: Colors.red, fontSize: 13)),
              Spacer(),
              SizedBox(
                width: 100,
                height: 32,
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  textColor: kPrimaryColor,
                  borderSide: BorderSide(color: kPrimaryColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        elevation: 24.0,
        backgroundColor: Colors.white,
      ),
    );
  }
}
