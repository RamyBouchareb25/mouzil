import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomboula/features/admin/data/models/participants.dart';
import 'package:tomboula/features/admin/data/repositories/participants_repo.dart';
import 'package:tomboula/features/auth/data/repositories/login_state.dart';
import 'package:tomboula/features/auth/providers/login_controller.dart';

class ParticipantsAdminProvider extends StateNotifier<List<Participant>> {
  ParticipantsAdminProvider(this._ref) : super([]);
  final Ref _ref;
  List<Participant> get participants => state;
  ParticipantsRepo get _participantsRepo => ParticipantsRepo();
  String get token => (_ref.read(loginControllerProvider) as LoginSuccess).token;
  void clear() {
    state = [];
  }

  Future<void> fetchParticipants() async {
    try {
      final participants = await _participantsRepo.fetchParticipants(token: token);
      state = participants;
    } catch (e) {
      rethrow;
    }
  }
}


final participantsAdminProvider = StateNotifierProvider<ParticipantsAdminProvider, List<Participant>>((ref) {
  return ParticipantsAdminProvider(ref);
});