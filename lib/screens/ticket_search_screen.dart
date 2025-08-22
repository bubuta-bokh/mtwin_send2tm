import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtwin_send2tm/bloc/ticket_bloc/ticket_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mtwin_send2tm/components/main_components/app_bar.dart';

class TicketSearchScreen extends StatelessWidget {
  const TicketSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController queryController = TextEditingController();
    final TextEditingController qtyController = TextEditingController();
    qtyController.text = '5';

    return Scaffold(
      appBar:
          appBarWithAllTokens(), //AppBar(title: const Text('Search Tickets')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar at the top
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: queryController,
                    decoration: const InputDecoration(
                      labelText:
                          'Введите номер или часть номер ЗБ или оставьте пустым для всех',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: qtyController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Кол-во',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search),

                  onPressed: () {
                    context.read<TicketBloc>().add(
                      TicketSearchEvent(
                        searchQuery: queryController.text,
                        qty: int.tryParse(qtyController.text),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Result list
            Expanded(
              child: BlocBuilder<TicketBloc, TicketState>(
                builder: (context, state) {
                  if (state is SearchTicketLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchTicketLoaded) {
                    final tickets = state.ticketsToSend; // List<Ticket>
                    return ListView.builder(
                      itemCount: tickets.length,
                      itemBuilder: (context, index) {
                        final ticket = tickets[index];
                        return Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Card(
                              elevation: 14,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          ticket.ticketObjectNumber,
                                          style: const TextStyle(
                                            letterSpacing: 1.7,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          ticket.uin,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(ticket.ticketObjectName),

                                        Text(
                                          'от ${ticket.soldDateReadable}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Add more fields later
                                    const Divider(),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context.goNamed(
                                            'ticketdetail',
                                            pathParameters: {
                                              'ticketObjectId':
                                                  ticket.ticketObjectId,
                                            },
                                          );
                                        },
                                        child: const Text('подробнее...'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is SearchTicketError) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const Center(
                    child: Text('Начните искать проданные вещи...'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
