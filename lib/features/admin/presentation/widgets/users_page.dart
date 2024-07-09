import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tomboula/features/admin/data/models/participants.dart';
import 'package:tomboula/features/admin/providers/participants_admin_provider.dart';
import 'package:tomboula/features/home/data/models/prize.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  bool _isloading = true;
  bool _isAssetImage = true;
  List<Participant> users = List.generate(
      10,
      (index) => Participant(
          firstName: 'User $index',
          lastName: 'User $index',
          phoneNumber: 'User $index',
          date: DateTime.now(),
          prize: Prize(
              name: 'Prize $index',
              coefficient: 0,
              id: "s",
              image: "assets/images/placeholder.png")));

  @override
  void initState() {
    super.initState();
    ref.read(participantsAdminProvider.notifier).fetchParticipants().then((_) {
      setState(() {
        _isloading = false;
        _isAssetImage = false;
        users = ref.read(participantsAdminProvider);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (!mounted) return;
        setState(() {
          _isloading = true;
        });
        await ref.read(participantsAdminProvider.notifier).fetchParticipants();
        if (!mounted) return;
        setState(() {
          users = ref.read(participantsAdminProvider);
          _isloading = false;
        });
      },
      child: users.isEmpty
          ? const Center(child: Text("Pas de participants pour l'instant !"))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var userName = users[index].firstName;
                var userLastName = users[index].lastName;
                var userPhoneNumber = users[index].phoneNumber;
                var userDate = users[index].date;
                var userPrize = users[index].prize;
                var userImage = userPrize.image;
                return Skeletonizer(
                  enabled: _isloading,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: _isAssetImage
                          ? AssetImage(userImage)
                          : NetworkImage(userImage) as ImageProvider,
                    ),
                    title: Text('$userName $userLastName'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone Number: $userPhoneNumber'),
                        Text(
                            'Date: ${userDate.toIso8601String().split('T').first} ${userDate.toIso8601String().split('T').last.split('.').first}'),
                        Text('Prize: ${userPrize.name}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
