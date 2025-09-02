import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mtwin_send2tm/bloc/ticket_bloc/ticket_bloc.dart';
import 'package:mtwin_send2tm/entities/ticket_dto.dart';
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
          //late TicketDto ticket;

          final bool exists = state.ticketsToSend.any(
            (ticket) => ticket.ticketObjectId == ticketObjectId,
          );

          if (exists == true) {
            var ticket = state.ticketsToSend.firstWhere(
              (t) => t.ticketObjectId == ticketObjectId,
            );

            // build the details page with the found ticket
            return TicketDetailsContent(ticket: ticket);
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Эта вещь была отправлена на ТМ'),
              ),
              body: Center(
                child: TextButton(
                  onPressed: () {
                    context.goNamed('home');
                  },
                  child: Text(
                    'Вещь уже была отправлена на ТМ. Вернитесь назад.',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            );
          }
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
