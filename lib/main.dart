import 'src/app.dart';

// รหัสที่ได้รับจากหน้าเว็บจัดการแอพ ( ความยาว 10 ตัวอักษร)
// หากกรอกค่านี้ แอพจะไม่แสดงหน้า Demo เพื่อให้กรอก Token
// ตัวอย่างการใส่เช่น  const IFELSE_TOKEN = '1:c1c16e82';
const IFELSE_TOKEN = '1:c1c16e82';

void main() {
  App.run(IFELSE_TOKEN);
}