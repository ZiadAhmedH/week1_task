abstract class Drink {
  String get name;
  double get price;
}

class TurkishCoffee extends Drink {
  @override
  String get name => 'Turkish Coffee';

  @override
  double get price => 10.0;
}

class Espresso extends Drink {
  @override
  String get name => 'Espresso';

  @override
  double get price => 12.0;
}

class Latte extends Drink {
  @override
  String get name => 'Latte';

  @override
  double get price => 15.0;
}

class DarkCoffee extends Drink {
  @override
  String get name => "Dark Coffee";

  @override
  double get price => 10.0;
}
