class Contract {
  final String address;

  final String tokenX;

  final String tokenY;

  final double fee;

  Contract(this.address, this.tokenX, this.tokenY, this.fee);

  static Contract fromJson(Map<String, dynamic> json) => Contract(
      json['address'] as String,
      json['tokenX'] as String,
      json['tokenY'] as String,
      json['fee'] as double);

  static Map<String, dynamic> toJson(Contract instance) => <String, dynamic>{
        'name': instance.address,
        'symbol': instance.tokenX,
        'icon': instance.tokenY,
        'iconBlack': instance.fee
      };
}
