import 'src/app.dart';

// รหัสที่ได้รับจากหน้าเว็บจัดการแอพ iOS/Android 
// หรือเข้าไปที่เว็บไซต์ของเรา เมนู "จัดการ" > "แอพ iOS/Android" > "ตั้งค่าแอพ"
// หากกรอกค่านี้ แอพจะไม่แสดงหน้า Demo เพื่อให้กรอก Token
// ตัวอย่างการใส่เช่น  const IFELSE_TOKEN = '1:cac64dad8a';
const IFELSE_TOKEN = '1:cac64dad8a';

void main() {
  App.run(IFELSE_TOKEN);
}
