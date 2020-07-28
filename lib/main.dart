import 'src/app.dart';
import 'src/site.dart';
import 'src/convert/gradient.dart';

void main() {
  // ******** บังคับเปลี่ยน ********
  // รหัสที่ได้รับจากหน้าเว็บจัดการแอพ iOS/Android
  // หรือเข้าไปที่เว็บไซต์ของเรา เมนู "จัดการ" > "แอพ iOS/Android" > "ตั้งค่าแอพ"
  // หากกรอกค่านี้ แอพจะไม่แสดงหน้า Demo เพื่อให้กรอก Token
  // ตัวอย่างการใส่เช่น  Site.token = '238:e03d4b199c';
  Site.token = '';

  // ไม่บังคับเปลี่ยน
  // ค่าเริ่มต้น สำหรับกรณีที่เปิดใช้งานครั้งแรก
  // หากต้องการเปลี่ยนรูปภาพในส่วนนี้ ให้แก้ที่ไฟล์รูป assets/splash-logo.png
  // ค่าสีของพื้นหลังหน้าโหลดแอพ
  // color1 = สีที่ 1
  // color2 = สีที่ 2
  // gradient = ใช้งาน 1 - 2 สี
  // range = มุมของการไล่สี (0, 45, 90, 135, 180, 225, 270, 315)
  Site.splashBackground = getGradient({'color1': '#2EBBDF', 'color2': '#4BE1C7', 'gradient': 2, 'range': 315});

  App.run();
}
