
double getDouble(dynamic val, [double def]) {
  if((val == null) || (val.toString().isEmpty)) {
    return def == null ? 0 :def;
  }
  return double.parse(val);
}
