void main() {
  String name = "Bekzat";
  int age = 25;
  double gpa = 3.4;
  bool isStudent = false;

  print("name : $name\nage: $age y.o.\ngpa: $gpa\nis Teacher: ${!isStudent}");

  String text1 = "Hello";
  // String nullText = null; not works
  String? text2 = null;
  print('text1: $text1');
  print('text2: $text2');

  int length1 = text1.length;
  int length2 = text2?.length ?? 0;
  print(length1);
  print(length2);

  String confirmedText = text2 ?? "default";
  print("confirmed $confirmedText length: ${confirmedText.length}");

  int digit = 3;
  print("MULTIPLICATION TABLE for digit $digit");
  for (int i = 1; i <= 10; i++) {
    print("$digit * $i = ${i * digit}");
  }

  for (int i = 10; i > 0; i--) {
    if (i % 2 == 0) {
      print("$i");
    } else {
      print("${i * 2}");
    }
  }
}

// TASK 1
// OUTPUT MULTIPLICATION TABLE  1-10

void main() {
  for (int number = 1; number <= 10; number++) {
    print("\n--Table Of $number--");
  for (int i = 1; i <= 10; i++) {
    print("$number * $i = ${number * i}");
  }
}
}

// TASK 2

void main() {
  var d1 = "05.09.2026"; // 06.09.2026
  var d2 = "28.02.2024"; // 29.02.2024
  var d3 = "28.02.2026"; // 01.03.2026
  var d4 = "29.02.2026"; // invalid date
  var d5 = "28.02.2100"; // 01.03.2100
  var d6 = "31.12.2025"; // 01.01.2026

  print(nextDate(d1));
  print(nextDate(d2));
  print(nextDate(d3));
  print(nextDate(d4));
  print(nextDate(d5));
  print(nextDate(d6));
}

String nextDate(String date) {
  var a = date.split(".");

  int day = int.parse(a[0]);
  int month = int.parse(a[1]);
  int year = int.parse(a[2]);

  int daysInMonth;

  if (month == 2) {
    // February
    if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
      daysInMonth = 29;
    } else {
      daysInMonth = 28;
    }
  } else if (month == 4 || month == 6 || month == 9 || month == 11) {
    daysInMonth = 30;
  } else {
    daysInMonth = 31;
  }
  
   if (day < 1 || day > daysInMonth || month < 1 || month > 12) {
    return "invalid date";
  }
  
  if (day < daysInMonth) {
    day++;
  } else {
    day = 1;

    if (month == 12) {
      month = 1;
      year++;
    } else {
      month++;
    }
  }

  return "$day.$month.$year";
}

// TASK3
// Vowel Counter in a String -> "flutter mobile development" -> 8

void main() {
  String text = "flutter mobile development";

  int result = countVowels(text);

  print('Text: "$text"');
  print("Number of vowels: $result");
}

int countVowels(String text) {
  int count = 0;

  String vowels = "aeiou";

  for (int i = 0; i < text.length; i++) {
    String letter = text[i].toLowerCase();

    if (vowels.contains(letter)) {
      count++;
    }
  }

  return count;
}



// TASK4
// Manual min & max finder

void main() {
  List<int> numbers = [14, 88, 3, 42, 99, 12, 67];
  List<int> numbers1 = [234, 34, 123, 44, 949, 112, 67];

  int first = numbers[0];
  int last = numbers[numbers.length - 1];

  print("First number: $first");
  print("Last number: $last");

  int min = numbers[0];
  int max = numbers[0];

  for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] < min) {
      min = numbers[i];
    }

    if (numbers[i] > max) {
      max = numbers[i];
    }
  }

  print("numbers: $numbers");
  print("Max: $max");
  print("Min: $min");

  int min1 = numbers1[0];
  int max1 = numbers1[0];

  for (int i = 0; i < numbers1.length; i++) {
    if (numbers1[i] < min1) {
      min1 = numbers1[i];
    }

    if (numbers1[i] > max1) {
      max1 = numbers1[i];
    }
  }

  print("numbers1: $numbers1");
  print("Max: $max1");
  print("Min: $min1");
}

// TASK 5
// Prime Number Checker
// 3 -> prime number
// 6 -> not prime number

void main() {
  int number1 = 3;
  int number2 = 6;

  if (isPrime(number1)) {
    print("$number1 is a prime number");
  } else {
    print("$number1 is not a prime number");
  }

  if (isPrime(number2)) {
    print("$number2 is a prime number");
  } else {
    print("$number2 is not a prime number");
  }
}

bool isPrime(int number) {
  if (number < 2) {
    return false;
  }

  for (int i = 2; i < number; i++) {
    if (number % i == 0) {
      return false;
    }
  }

  return true;
}