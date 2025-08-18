import 'dart:ffi';

class TicketDto {
  final String ticketId;
  final String ticketNumber;
  final String soldDate;
  final String ticketName;
  final int chequeNumber;
  final Float sellPrice;
  final String uin;

  TicketDto({
    required this.ticketId,
    required this.ticketNumber,
    required this.soldDate,
    required this.ticketName,
    required this.chequeNumber,
    required this.sellPrice,
    required this.uin,
  });

  factory TicketDto.fromJson(Map<String, dynamic> json) => TicketDto(
    ticketId: json["ticketId"] ?? 'n/a',
    ticketNumber: json['ticketNumber'] ?? 'n/a',
    soldDate: json['soldDate'] ?? 'n/a',
    ticketName: json['ticketName'] ?? 'n/a',
    chequeNumber: json['chequeNumber'] ?? 0,
    sellPrice: json['sellPrice'] != null ? json['sellPrice'].toDouble() : 0.0,
    uin: json['uin'] ?? 'n/a',
  );
}
