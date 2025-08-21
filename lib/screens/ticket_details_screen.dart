import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtwin_send2tm/bloc/ticket_bloc/ticket_bloc.dart';
import 'package:mtwin_send2tm/screens/ticket_details_content.dart';

class TicketDetailsScreen extends StatelessWidget {
  final String? ticketObjectId; // received as path parameter

  const TicketDetailsScreen({super.key, required this.ticketObjectId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketBloc, TicketState>(
      builder: (context, state) {
        if (state is SearchTicketLoaded) {
          // Find the ticket in the state
          final ticket = state.ticketsToSend.firstWhere(
            (t) => t.ticketObjectId == ticketObjectId,
          );
          if (ticket == null) {
            return Scaffold(body: Center(child: Text('Ticket not found!')));
          }
          // build the details page with the found ticket
          return TicketDetailsContent(ticket: ticket);
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
