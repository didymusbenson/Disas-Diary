/// Model class representing a Magic: The Gathering card/token
class Item {
  String abilities;
  String name;
  String pt;
  String colors;
  int amount;
  int tapped;

  Item({
    required this.abilities,
    required this.name,
    required this.pt,
    required this.colors,
    required this.amount,
    required bool createTapped,
  }) : tapped = createTapped ? amount : 0 {
    // Ensure colors are uppercase
    this.colors = colors.toUpperCase();
  }

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'abilities': abilities,
      'name': name,
      'pt': pt,
      'colors': colors,
      'amount': amount,
      'tapped': tapped,
    };
  }

  /// Create from JSON
  factory Item.fromJson(Map<String, dynamic> json) {
    final item = Item(
      abilities: json['abilities'] as String,
      name: json['name'] as String,
      pt: json['pt'] as String,
      colors: json['colors'] as String,
      amount: json['amount'] as int,
      createTapped: false,
    );
    item.tapped = json['tapped'] as int;
    return item;
  }

  /// Create a copy with optional field updates
  Item copyWith({
    String? abilities,
    String? name,
    String? pt,
    String? colors,
    int? amount,
    int? tapped,
  }) {
    final newItem = Item(
      abilities: abilities ?? this.abilities,
      name: name ?? this.name,
      pt: pt ?? this.pt,
      colors: colors ?? this.colors,
      amount: amount ?? this.amount,
      createTapped: false,
    );
    newItem.tapped = tapped ?? this.tapped;
    return newItem;
  }
}
