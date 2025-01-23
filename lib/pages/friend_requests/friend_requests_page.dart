import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/pages/friend_requests/friend_request_cubit.dart';

class FriendRequestsPage extends StatelessWidget {
  const FriendRequestsPage({super.key});

  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const FriendRequestsPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendRequestCubit(
        userId: context.read<AppCubit>().state.user!.uid,
        userRepository: context.read<AppCubit>().userRepository,
      ),
      child: Builder(builder: (context) {
        return const _FriendRequestPage();
      }),
    );
  }
}

class _FriendRequestPage extends StatefulWidget {
  const _FriendRequestPage({super.key});

  @override
  State<_FriendRequestPage> createState() => __FriendRequestPageState();
}

class __FriendRequestPageState extends State<_FriendRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friends and Requests"),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppPadding.page,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            // Received Requests Section
            const Text(
              'Received Requests',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            ListView.builder(
              itemCount: 5, // Replace with your dynamic data length
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: Text(
                      'R$index', 
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text('Request ${index + 1}'),
                  subtitle: const Text('Received Request'),
                  trailing: const Icon(
                    Icons.inbox,
                    color: Colors.red,
                  ),
                );
              },
            ),
            const Divider(height: 20, color: Colors.grey),

            const Text(
              'Sent Requests',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            ListView.builder(
              itemCount: 5, 
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      'S$index',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text('Request ${index + 1}'), 
                  subtitle: const Text('Sent Request'),
                  trailing: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                );
              },
            ),
            const Divider(height: 20, color: Colors.grey),

            const Text(
              'All Friends',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            ListView.builder(
              itemCount: 10, 
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      'F$index',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text('Friend ${index + 1}'),
                  subtitle: const Text('Active Now'),
                  trailing: const Icon(
                    Icons.message,
                    color: Colors.green,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
