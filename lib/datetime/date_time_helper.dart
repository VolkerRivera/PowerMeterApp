// convert DateTime object to String yyyymmdd
String convertDateTimeToString (DateTime dateTime){ // en nuestro caso le tendremos que pasar un string con el timestamp y que lo formatee de ahi
  // yaer in the format -> yyyy
  String year = dateTime.year.toString();

  // month in the format -> mm
  String month = dateTime.month.toString();
  if (month.length == 1){
    month = '0$month';
  }

  // day in the format -> dd
  String day = dateTime.day.toString();
  if (day.length == 1){
    day = '0$day';
  }

  // final format yyyymmdd
  String yyyymmdd = year + month + day;

  return yyyymmdd; 
}

//convert DateTime object to String yyyymm
String convertDateTimeToMonthString (DateTime dateTime){ // en nuestro caso le tendremos que pasar un string con el timestamp y que lo formatee de ahi
  // yaer in the format -> yyyy
  String year = dateTime.year.toString();

  // month in the format -> mm
  String month = dateTime.month.toString();
  if (month.length == 1){
    month = '0$month';
  }

  // final format yyyymmdd
  String yyyymm = year + month;

  return yyyymm; 
}