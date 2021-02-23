import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gegeengii_app/constants.dart';

class Bank extends StatefulWidget {
  final BuildContext ctx;

  Bank({Key key, this.ctx});

  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<Bank> {
  final List<Map<String, dynamic>> bankUrls = [
    {
      "name": "Khan bank",
      "description": "Хаан банк",
      "logo": "https://qpay.mn/q/logo/khanbank.png",
      "link":
          "khanbank://q?qPay_QRcode=0002010102121531279404962794049600000000KKTQPAY52046010530349654031005802MN5912TESTMERCHANT6011Ulaanbaatar6244010712345670504test0721o81Dmyc23_t_GCJfKodog6304882E"
    },
    {
      "name": "State bank",
      "description": "Төрийн банк",
      "logo": "https://qpay.mn/q/logo/statebank.png",
      "link":
          "statebank://q?qPay_QRcode=0002010102121531279404962794049600000000KKTQPAY52046010530349654031005802MN5912TESTMERCHANT6011Ulaanbaatar6244010712345670504test0721o81Dmyc23_t_GCJfKodog6304882E"
    },
    {
      "name": "Xac bank",
      "description": "Хас банк",
      "logo": "https://qpay.mn/q/logo/xacbank.png",
      "link":
          "xacbank://q?qPay_QRcode=0002010102121531279404962794049600000000KKTQPAY52046010530349654031005802MN5912TESTMERCHANT6011Ulaanbaatar6244010712345670504test0721o81Dmyc23_t_GCJfKodog6304882E"
    },
    {
      "name": "Trade and Development bank",
      "description": "TDB online",
      "logo": "https://qpay.mn/q/logo/tdbbank.png",
      "link":
          "tdbbank://q?qPay_QRcode=0002010102121531279404962794049600000000KKTQPAY52046010530349654031005802MN5912TESTMERCHANT6011Ulaanbaatar6244010712345670504test0721o81Dmyc23_t_GCJfKodog6304882E"
    },
    {
      "name": "Most money",
      "description": "МОСТ мони",
      "logo": "https://qpay.mn/q/logo/most.png",
      "link":
          "most://q?qPay_QRcode=0002010102121531279404962794049600000000KKTQPAY52046010530349654031005802MN5912TESTMERCHANT6011Ulaanbaatar6244010712345670504test0721o81Dmyc23_t_GCJfKodog6304882E"
    },
    {
      "name": "National investment bank",
      "description": "Үндэсний хөрөнгө оруулалтын банк",
      "logo": "https://qpay.mn/q/logo/nibank.jpeg",
      "link":
          "nibank://q?qPay_QRcode=0002010102121531279404962794049600000000KKTQPAY52046010530349654031005802MN5912TESTMERCHANT6011Ulaanbaatar6244010712345670504test0721o81Dmyc23_t_GCJfKodog6304882E"
    },
    {
      "name": "Chinggis khaan bank",
      "description": "Чингис Хаан банк",
      "logo": "https://qpay.mn/q/logo/ckbank.png",
      "link":
          "ckbank://q?qPay_QRcode=0002010102121531279404962794049600000000KKTQPAY52046010530349654031005802MN5912TESTMERCHANT6011Ulaanbaatar6244010712345670504test0721o81Dmyc23_t_GCJfKodog6304882E"
    },
    {
      "name": "Capitron bank",
      "description": "Капитрон банк",
      "logo": "https://qpay.mn/q/logo/capitronbank.png",
      "link":
          "capitronbank://q?qPay_QRcode=0002010102121531279404962794049600000000KKTQPAY52046010530349654031005802MN5912TESTMERCHANT6011Ulaanbaatar6244010712345670504test0721o81Dmyc23_t_GCJfKodog6304882E"
    },
    {
      "name": "Bogd bank",
      "description": "Богд банк",
      "logo": "https://qpay.mn/q/logo/bogdbank.png",
      "link":
          "bogdbank://q?qPay_QRcode=0002010102121531279404962794049600000000KKTQPAY52046010530349654031005802MN5912TESTMERCHANT6011Ulaanbaatar6244010712345670504test0721o81Dmyc23_t_GCJfKodog6304882E"
    },
    {
      "name": "qPay wallet",
      "description": "qPay хэтэвч",
      "logo":
          "https://s3.qpay.mn/p/e9bbdc69-3544-4c2f-aff0-4c292bc094f6/launcher-icon-ios.jpg",
      "link":
          "qpaywallet://q?qPay_QRcode=0002010102121531279404962794049600000000KKTQPAY52046010530349654031005802MN5912TESTMERCHANT6011Ulaanbaatar6244010712345670504test0721o81Dmyc23_t_GCJfKodog6304882E"
    }
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DropdownButton(
          isExpanded: true,
          value: _selectedIndex,
          items: bankUrls.map((dynamic data) {
            var index = bankUrls.indexOf(data);
            return DropdownMenuItem(
              value: index,
              child: Row(
                children: [
                  Image.network(data["logo"], width: 22),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      data["description"],
                      style: TextStyle(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            print(val);
            setState(() {
              _selectedIndex = val;
            });
          },
        ),
        SizedBox(
          width: 100,
          height: 32,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textColor: kPrimaryColor,
            onPressed: () async {
              String bankUrl = bankUrls[_selectedIndex]["link"];
              if (await canLaunch(bankUrl)) {
                await launch(bankUrl);
              } else {
                Flushbar(
                  title: "Анхааруулга",
                  icon: Icon(
                    Icons.info_outline,
                    size: 28.0,
                    color: Colors.blue[300],
                  ),
                  message:
                      "${bankUrls[_selectedIndex]["description"]}ны апп олдсонгүй",
                  duration: Duration(seconds: 4),
                )..show(widget.ctx);
              }
            },
            child: Text(
              'апп нээх',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
