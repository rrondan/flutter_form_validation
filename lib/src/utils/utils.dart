
bool isNumeric( String s){
  if(s.trim().isEmpty) return false;

  final number = num.tryParse(s);

  return number != null;
}

