int dateToUnix(DateTime date){
  return (date.millisecondsSinceEpoch / 1000).round();
}