import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mtwin_send2tm/bloc/dmdk_bloc/dmdk_bloc.dart';
import 'package:mtwin_send2tm/entities/ticket_dto.dart';

class TicketDetailsContent extends StatelessWidget {
  final TicketDto ticket;

  const TicketDetailsContent({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    // Make a copy of controllers for editable fields

    final TextEditingController ticketNumberController = TextEditingController(
      text: ticket.ticketNumber,
    );
    final TextEditingController ticketObjectNumberController =
        TextEditingController(text: ticket.ticketObjectNumber);
    final TextEditingController soldDateController = TextEditingController(
      text: ticket.soldDate,
    );
    final TextEditingController ticketObjectNameController =
        TextEditingController(text: ticket.ticketObjectName);
    final TextEditingController chequeController = TextEditingController(
      text: ticket.chequeNumber,
    );
    final TextEditingController shiftController = TextEditingController(
      text: ticket.shiftNumber,
    );
    final TextEditingController sellPriceController = TextEditingController(
      text: ticket.sellPrice.toString(),
    );
    final TextEditingController uinController = TextEditingController(
      text: ticket.uin,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(ticket.ticketObjectName),
        backgroundColor: Colors.tealAccent[700],
        leading: Material(
          color: Colors.transparent,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => context.goNamed('home'),
            splashRadius: 24,
            tooltip: 'На страницу поиска',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: ListView(
          children: [
            _buildEditableField('Номер ЗБ', ticketNumberController, true),
            const SizedBox(height: 12),
            _buildEditableField(
              'Номер вещи',
              ticketObjectNumberController,
              true,
            ),
            const SizedBox(height: 12),
            _buildEditableField(
              'Дата продажи для ТМ',
              soldDateController,
              false,
            ),
            const SizedBox(height: 12),
            _buildEditableField(
              'Название вещи',
              ticketObjectNameController,
              false,
            ),

            const SizedBox(height: 12),
            _buildEditableField('Номер чека', chequeController, false),
            const SizedBox(height: 12),
            _buildEditableField('Номер смены', shiftController, false),
            const SizedBox(height: 12),
            _buildEditableField('Сумма продажи', sellPriceController, false),
            const SizedBox(height: 12),
            _buildEditableField('УИН', uinController, true),
            // Add more field widgets as necessary...
          ],
        ),
        //   ],
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.play_arrow),
        onPressed: () {
          final updatedTicket = ticket.copyWith(
            chequeNumber: chequeController.text,
            shiftNumber: shiftController.text,
            sellPrice:
                double.tryParse(sellPriceController.text) ?? ticket.sellPrice,

            soldDate: soldDateController.text,
            ticketObjectName: ticketObjectNameController.text,
          );
          context.read<DmdkBloc>().add(ProcessTicketSendEvent(updatedTicket));
        },
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    bool readOnlyField,
  ) {
    return TextField(
      controller: controller,
      readOnly: readOnlyField,
      style: readOnlyField ? TextStyle(color: Colors.grey) : null,
      decoration: InputDecoration(
        labelText: label,
        fillColor: Colors.grey.shade100,
        filled: readOnlyField,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
