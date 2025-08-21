import 'dart:ffi';

class TicketDto {
  final String ticketObjectId;
  final String ticketNumber;
  final String ticketObjectNumber;
  final String soldDate;
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
    ticketObjectName: json['ticketObjectName'] ?? 'n/a',
    chequeNumber: json['chequeNumber'] ?? 'n/a',
    shiftNumber: json['shiftNumber'] ?? 'n/a',
    sellPrice: json["sellPrice"] ?? -1,
    uin: json['uin'] ?? 'n/a',
  );
}
