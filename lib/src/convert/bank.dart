import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'util.dart';

class Bank {
  static Map<String,Map> all = {
    'bbl': { 'code': '002', 'color': '#1e4598', 'th': 'กรุงเทพ', 'en': 'Bangkok Bank' },
    'kbank': { 'code': '004', 'color': '#138f2d', 'th': 'กสิกร', 'en': 'Kasikornbank' },
    'bay': { 'code': '025', 'color': '#fec43b', 'th': 'กรุงศรีอยุธยา', 'en': 'Bank of Ayudhya (Krungsri)' },
    'ktb': { 'code': '006', 'color': '#1ba5e1', 'th': 'กรุงไทย', 'en': 'Krungthai Bank' },
    'tmb': { 'code': '011', 'color': '#1279be', 'th': 'ทหารไทย', 'en': 'TMB Bank' },
    'scb': { 'code': '014', 'color': '#4e2e7f', 'th': 'ไทยพาณิชย์', 'en': 'Siam Commercial Bank' },
    'tbank': { 'code': '065', 'color': '#fc4f1f', 'th': 'ธนชาต', 'en': 'Thanachart Bank' },
    'gsb': { 'code': '030', 'color': '#eb198d', 'th': 'ออมสิน', 'en': 'Government Savings Bank' },
    'ghb': { 'code': '033', 'color': '#f57d23', 'th': 'อาคารสงเคราะห์', 'en': 'Government Housing Bank' },
    'kk': { 'code': '069', 'color': '#199cc5', 'th': 'เกียรตินาคิน', 'en': 'Kiatnakin Bank' },
    'tisco': { 'code': '067', 'color': '#12549f', 'th': 'ทิสโก้', 'en': 'Tisco Bank' },
    'citi': { 'code': '017', 'color': '#1583c7', 'th': 'ซิตี้แบงก์', 'en': 'Citibank' },
    'smbc': { 'code': '018', 'color': '#a0d235', 'th': 'ซูมิโตโม มิตซุย แบงกิ้ง คอร์ปอเรชั่น', 'en': 'Sumitomo Mitsui Banking Corporation' },
    'sc': { 'code': '020', 'color': '#0f6ea1', 'th': 'สแตนดาร์ดชาร์เตอร์ด', 'en': 'Standard Chartered (Thai)' },
    'cimb': { 'code': '022', 'color': '#7e2f36', 'th': 'ซีไอเอ็มบี ไทย', 'en': 'CIMB Thai Bank' },
    'uob': { 'code': '024', 'color': '#0b3979', 'th': 'ยูโอบี', 'en': 'United Overseas Bank (Thai)' },
    'mega': { 'code': '026', 'color': '#815e3b', 'th': 'เมกะ สากลพาณิชย์', 'en': 'Mega International Commercial Bank' },
    'hsbc': { 'code': '031', 'color': '#fd0d1b', 'th': 'ฮ่องกงและเซี่ยงไฮ้แบงกิ้งคอร์ปอเรชั่น', 'en': 'Hongkong and Shanghai Banking Corporation' },
    'baac': { 'code': '034', 'color': '#4b9b1d', 'th': 'เพื่อการเกษตรและสหกรณ์การเกษตร', 'en': 'Bank for Agriculture and Agricultural Cooperatives' },
    'mb': { 'code': '039', 'color': '#150b78', 'th': 'มิซูโฮ', 'en': 'Mizuho Bank' },
    'ibank': { 'code': '066', 'color': '#184615', 'th': 'อิสลามแห่งประเทศไทย', 'en': 'Islamic Bank of Thailand' },
    'icbc': { 'code': '070', 'color': '#c50f1c', 'th': 'ไอซีบีซี (ไทย)', 'en': 'Industrial and Commercial Bank of China (Thai)' },
    'tcrb': { 'code': '071', 'color': '#0a4ab3', 'th': 'ไทยเครดิต เพื่อรายย่อย', 'en': 'Thai Credit Retail Bank' },
    'lhb': { 'code': '073', 'color': '#6d6e71', 'th': 'แลนด์ แอนด์ เฮ้าส์', 'en': 'Land and Houses Bank' }
  };

  static Widget getWidget(String abbr) {
    if((abbr != null) && (abbr.isNotEmpty) && (all[abbr] != null)) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: getColor(all[abbr]['color']),
        ),
        width: 50,
        height: 50,
        padding: EdgeInsets.all(10),
        child: SvgPicture.asset(
          'assets/bank/' + abbr + '.svg',
          color: Colors.white,
        ),
      );
    }
    return Container();
  }

  static String getName(String abbr) {
    if((abbr != null) && (abbr.isNotEmpty) && (all[abbr] != null)) {
      return all[abbr]['th'];
    }
    return '';
  }
}