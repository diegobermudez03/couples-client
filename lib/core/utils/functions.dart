int dateToUnix(DateTime date){
  return (date.millisecondsSinceEpoch / 1000).round();
}

DateTime unixToDate(int unix){
  return DateTime.fromMillisecondsSinceEpoch(unix * 1000);
}