
String getImage(dynamic obj, [String size, String service]) {
  if ((obj != null) && !(obj is List)) {
    size ??= 'o';
    if (obj[size] == null) {
      size = 'o';
    }
    if (obj[size] != null) {      
      return 'https://' + (obj['server'] ?? 'f1') + '.ifelse.co/' + 
              (service ?? 'site') + '/' + obj['path']  + '/' + obj['_id'].toString() + '/' +
              obj['key'] + (size != 'o'?'-'+size:'') + '.' + obj[size]['ext'];
    }
  }
  return null;
}

dynamic getImageObj(dynamic obj, [String size, String service]) {
  if ((obj != null) && !(obj is List)) {
    size ??= 'o';
    if (obj[size] == null) {
      size = 'o';
    }
    if (obj[size] != null) {      
      return {
        'src': 'https://' + (obj['server'] ?? 'f1') + '.ifelse.co/' + 
              (service ?? 'site') + '/' + obj['path']  + '/' + obj['_id'].toString() + '/' +
              obj['key'] + (size != 'o'?'-'+size:'') + '.' + obj[size]['ext'],
        'ext': obj[size]['ext'],
        'size': size,
        'width': obj[size]['w'],
        'height': obj[size]['h'],
      };
    }
  }
  return null;
}