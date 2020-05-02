
int getInt(dynamic val, [int def]) {
  if((val == null) || (val.toString().isEmpty)) {
    return def == null ? 0 :def;
  }
  return int.parse(val);
}
