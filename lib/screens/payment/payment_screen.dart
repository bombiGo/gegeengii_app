import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/constants.dart';
import 'components/bank.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:http/http.dart' as http;
import 'package:gegeengii_app/utils/shared_preference.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';

Future<void> fetchUser() async {
  final response = await http.get(AppUrl.baseURL + "/me");
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw "Can't get user information";
  }
}

class PaymentScreen extends StatefulWidget {
  static String routeName = "/payment";

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

enum PaymentCharacter { qpay, card }

class _PaymentScreenState extends State<PaymentScreen> {
  Future<void> futureUser;
  PaymentCharacter _payment = PaymentCharacter.qpay;
  String _authToken;

  Future<void> fetchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("token") ?? null);

    _authToken = token;

    if (token != null) {
      final response = await http.get(AppUrl.baseURL + "/me", headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        return body;
      } else {
        UserPreferences().removeUser();
        Future.delayed(Duration(milliseconds: 0)).then((_) {
          Navigator.pushReplacementNamed(context, '/home');
          Flushbar(
            title: "Анхааруулга",
            message: "Та нэвтрэх хэрэгтэй",
            duration: Duration(seconds: 5),
          )..show(context);
        });
      }
    } else {
      UserPreferences().removeUser();
      Future.delayed(Duration(milliseconds: 0)).then((_) {
        Navigator.pushReplacementNamed(context, '/home');
        Flushbar(
          title: "Анхааруулга",wx
          message: "Та нэвтрэх хэрэгтэй",
          duration: Duration(seconds: 5),
        )..show(context);
      });
    }
  }

  String moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    } else {
      return "0";
    }
  }

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    int coursePrice = 100;

    if (args["course_price"] != null) {
      coursePrice = int.parse(args["course_price"]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Төлбөр төлөх"),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("snapshot: {$snapshot.data}");
            return Builder(
              builder: (BuildContext context) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          alignment: Alignment.center,
                          child: Text(
                            args['course_title'].toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                              'Та төлбөр төлснөөр энэ хөтөлбөрийн бүх өдрүүдийн мэдээллэлийг үргэлж харах боломжтой болно.'),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text(
                            '${moneyFormat(args['course_price'].toString())} ₮',
                            style: TextStyle(
                              fontSize: 30,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text('Төлбөрийн сонголт'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Radio(
                              value: PaymentCharacter.qpay,
                              groupValue: _payment,
                              onChanged: (PaymentCharacter value) {
                                setState(() {
                                  _payment = value;
                                });
                              },
                            ),
                            Text('QPAY'),
                            SizedBox(width: 20),
                            Radio(
                              value: PaymentCharacter.card,
                              groupValue: _payment,
                              onChanged: (PaymentCharacter value) {
                                setState(() {
                                  _payment = value;
                                });
                              },
                            ),
                            Text('Дансруу'),
                          ],
                        ),
                        if (_payment == PaymentCharacter.qpay)
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                                'QPAY төлбөрийн систем дэмждэг банкуудын аппаас QR кодоо уншуулан төлбөрөө төлөх бүрэн боломжтой.'),
                          ),
                        if (_payment == PaymentCharacter.card)
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                                'Та хаан банк 5050XXXXXX, Голомт банк 3155XXXXXX, Худалдаа хөгжил 4100XXXXX тоот дансруу мөн гүйлгээний утган дээр утасны дугаар 9911XXXX бичиж төлбөр төлөх бүрэн боломжтой. Төлбөр төлж захиалга хийгдсэнээс хойш тун удахгүй таны утсанд мэдэгдэл очих болно.'),
                          ),
                        Container(
                          margin: EdgeInsets.all(20),
                          width: 220,
                          height: 50,
                          child: ProgressButton(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            strokeWidth: 2,
                            color: kPrimaryColor,
                            child: Text(
                              "Захиалга өгөх",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                            onPressed: (AnimationController controller) async {
                              controller.forward();

                              print("authToken: $_authToken");

                              if (_authToken != null) {
                                String _qpayInvoiceUrl =
                                    "https://merchant-sandbox.qpay.mn/v2/invoice";
                                String _qpayAccessToken =
                                    snapshot.data["qpay_access_token"];

                                if (_qpayAccessToken != null) {
                                  final Map<String, dynamic> formData = {
                                    'invoice_code': 'TEST_INVOICE',
                                    'sender_invoice_no': '1234567',
                                    'invoice_receiver_code': 'terminal',
                                    'invoice_description': 'test',
                                    'amount': coursePrice,
                                    'callback_url':
                                        'https://bd5492c3ee85.ngrok.io/payments?payment_id=1234567',
                                  };

                                  var response = await http.post(
                                    _qpayInvoiceUrl,
                                    headers: {
                                      'Authorization':
                                          'Bearer $_qpayAccessToken',
                                      'Content-Type': 'application/json',
                                      'Accept': 'application/json',
                                    },
                                    body: json.encode(formData),
                                  );

                                  print("request invoice");
                                  print(_qpayAccessToken);
                                  print(response.statusCode);
                                  print(response.body);

                                  if (response.statusCode == 200) {
                                    controller.reset();
                                    var data = json.decode(response.body);
                                    showInvoiceDialog(data["qr_image"]);
                                  } else if (response.statusCode == 401) {
                                    // GET AGAIN ACCESS TOKEN
                                    var responseData = await http.post(
                                        AppUrl.baseURL + "/qpay/token",
                                        headers: {
                                          'Authorization': 'Bearer $_authToken',
                                          'Content-Type': 'application/json',
                                          'Accept': 'application/json',
                                        });

                                    if (responseData.statusCode == 200) {
                                      controller.reset();
                                      var data = json.decode(responseData.body);
                                      print("data: $data");
                                      if (data["success"]) {
                                        var newAccessToken =
                                            data["access_token"];
                                        var response2 = await http.post(
                                          _qpayInvoiceUrl,
                                          headers: {
                                            'Authorization':
                                                'Bearer $newAccessToken',
                                            'Content-Type': 'application/json',
                                            'Accept': 'application/json',
                                          },
                                          body: json.encode(formData),
                                        );

                                        if (response2.statusCode == 200) {
                                          var data =
                                              json.decode(response2.body);
                                          showInvoiceDialog(data["qr_image"]);
                                        } else {
                                          showAlertDialog();
                                        }
                                      } else {
                                        showAlertDialog();
                                      }
                                    } else {
                                      controller.reset();
                                      showAlertDialog();
                                    }
                                  } else {
                                    controller.reset();
                                    showAlertDialog();
                                  }
                                } else {
                                  controller.reset();
                                  UserPreferences().removeUser();
                                  Navigator.pushNamed(context, "/login");
                                }
                              } else {
                                controller.reset();
                                UserPreferences().removeUser();
                                Navigator.pushNamed(context, "/login");
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
        },
      ),
    );
  }

  void showInvoiceDialog(String qrImage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.all(15),
        content: SizedBox(
          height: 385,
          child: Column(
            children: <Widget>[
              Text(
                'Төлбөрийн нэхэмжлэл амжилттай үүслээ. Та доорх QRCODE ийг уншуулж төлбөр тооцоогоо хийснээр захиалга баталгаажих болно.',
                style: TextStyle(fontSize: 12.0),
              ),
              Image.memory(
                base64Decode(qrImage),
                width: 200,
                height: 200,
              ),
              Container(
                margin: EdgeInsets.all(0),
                width: 170,
                height: 32,
                child: ProgressButton(
                  borderRadius: BorderRadius.all(
                    Radius.circular(26),
                  ),
                  strokeWidth: 1,
                  progressIndicatorSize: 20,
                  color: kPrimaryColor,
                  child: Text(
                    "Төлбөр шалгах",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  onPressed: (AnimationController controller) async {
                    // controller.forward();
                  },
                ),
              ),
              Bank(ctx: context),
            ],
          ),
        ),
        elevation: 24.0,
        backgroundColor: Colors.white,
      ),
    );
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text('Систем завгүй байна. Түр хүлээгээд дахин оролдоно уу!'),
      ),
    );
    Navigator.pushNamed(context, "/home");
  }
}
