import 'dart:ffi';

class TicketDto {
  final String ticketObjectId;
  final String ticketNumber;
  final String ticketObjectNumber;
  final String soldDate;
  final String soldDateReadable;
  final String ticketObjectName;
  final String chequeNumber;
  final String shiftNumber;
  final double sellPrice;
  final String uin;

  TicketDto({
    required this.ticketObjectId,
    required this.ticketNumber,
    required this.ticketObjectNumber,
    required this.soldDate,
    required this.soldDateReadable,
    required this.ticketObjectName,
    required this.chequeNumber,
    required this.shiftNumber,
    required this.sellPrice,
    required this.uin,
  });

  factory TicketDto.fromJson(Map<String, dynamic> json) => TicketDto(
    ticketObjectId: json["ticketObjectId"] ?? 'n/a',
    ticketNumber: json['ticketNumber'] ?? 'n/a',
    ticketObjectNumber: json['ticketObjectNumber'] ?? 'n/a',
    soldDate: json['soldDate'] ?? 'n/a',
    soldDateReadable: json['soldDateReadable'] ?? 'n/a',
    ticketObjectName: json['ticketObjectName'] ?? 'n/a',
    chequeNumber: json['chequeNumber'] ?? 'n/a',
    shiftNumber: json['shiftNumber'] ?? 'n/a',
    sellPrice: json["sellPrice"] ?? -1,
    uin: json['uin'] ?? 'n/a',
  );

  TicketDto copyWith({
    String? chequeNumber,
    String? shiftNumber,
    double? sellPrice,
    String? soldDate,
    String? ticketObjectName,
  }) {
    return TicketDto(
      ticketObjectId: ticketObjectId,
      chequeNumber: chequeNumber ?? this.chequeNumber,
      shiftNumber: shiftNumber ?? this.shiftNumber,
      sellPrice: sellPrice ?? this.sellPrice,
      soldDate: soldDate ?? this.soldDate,
      soldDateReadable: soldDateReadable,
      ticketObjectName: ticketObjectName ?? this.ticketObjectName,
      ticketNumber: ticketNumber,
      ticketObjectNumber: ticketObjectNumber,
      uin: uin,
    );
  }
}
