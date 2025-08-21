import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtwin_send2tm/bloc/dmdk_bloc/dmdk_bloc.dart';
import 'package:mtwin_send2tm/entities/ticket_dto.dart';

class TicketDetailsContent extends StatelessWidget {
  final TicketDto ticket;

  const TicketDetailsContent({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    // Make a copy of controllers for editable fields
    final TextEditingController nameController = TextEditingController(
      text: ticket.ticketObjectName,
    );
    final TextEditingController numberController = TextEditingController(
      text: ticket.ticketNumber,
    );

    // Add more controllers for other fields as needed

    return Scaffold(
      appBar: AppBar(title: Text('Ticket #${ticket.ticketNumber}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildEditableField('Ticket Number', numberController),
            const SizedBox(height: 12),
            _buildEditableField('Ticket Name', nameController),

            // Add more field widgets as necessary...
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.play_arrow),
        onPressed: () {
          context.read<DmdkBloc>().add(ProcessTicketSendEvent(ticket));
        },
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
