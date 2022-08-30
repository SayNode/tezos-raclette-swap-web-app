class Token {
  final String name;

  final String symbol;

  final String icon;

  final String iconBlack;

  final String tokenAddress;

  final String id;

  Token(this.name, this.symbol, this.icon, this.iconBlack, this.tokenAddress,
      this.id);

  static Token fromJson(Map<String, dynamic> json) => Token(
        json['name'] as String,
        json['symbol'] as String,
        json['icon'] as String,
        json['iconBlack'] as String,
        json['tokenAddress'] as String,
        json['id'] as String,
      );

  static Map<String, dynamic> toJson(Token instance) => <String, dynamic>{
        'name': instance.name,
        'symbol': instance.symbol,
        'icon': instance.icon,
        'iconBlack': instance.iconBlack,
        'tokenAddress': instance.tokenAddress,
        'id': instance.id
      };
}
