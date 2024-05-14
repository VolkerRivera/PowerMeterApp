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

//convert month from number to name 
String nombreMes(DateTime mes){
  String mesString;
  switch(mes.month){
    case 1:
      mesString = 'ene';
      break;
    case 2:
      mesString = 'feb';
      break;
    case 3:
      mesString = 'mar';
      break;
    case 4:
      mesString = 'abr';
      break;
    case 5:
      mesString = 'may';
      break;
    case 6:
      mesString = 'jun';
      break;
    case 7:
      mesString = 'jul';
      break;
    case 8:
      mesString = 'ago';
      break;
    case 9:
      mesString = 'sep';
      break;
    case 10:
      mesString = 'oct';
      break;
    case 11:
      mesString = 'nov';
      break;
    case 12:
      mesString = 'dic';
      break;
    default:
    mesString = '';
    break;
  }
return mesString;
}