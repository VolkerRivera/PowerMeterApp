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

//convert DateTime object to String yyyymmddhh
String convertDateTimeToHourString (DateTime dateTime){
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

  //hour of that timestamp
  String hour = dateTime.hour.toString();
  if (hour.length == 1){
    hour = '0$hour';
  }

  // final format yyyymmddhh
  String yyyymmddhh = year + month + day + hour;

  return yyyymmddhh;
}

//convert month from number to name 
String nombreMes(DateTime mes){
  String mesString;
  switch(mes.month){
    case 1:
      mesString = 'enero';
      break;
    case 2:
      mesString = 'febrero';
      break;
    case 3:
      mesString = 'marzo';
      break;
    case 4:
      mesString = 'abril';
      break;
    case 5:
      mesString = 'mayo';
      break;
    case 6:
      mesString = 'junio';
      break;
    case 7:
      mesString = 'julio';
      break;
    case 8:
      mesString = 'agosto';
      break;
    case 9:
      mesString = 'septiembre';
      break;
    case 10:
      mesString = 'octubre';
      break;
    case 11:
      mesString = 'noviembre';
      break;
    case 12:
      mesString = 'diciembre';
      break;
    default:
    mesString = '';
    break;
  }
return mesString;
}