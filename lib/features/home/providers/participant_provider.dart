import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomboula/features/auth/data/repositories/login_state.dart';
import 'package:tomboula/features/auth/providers/login_controller.dart';
import 'package:tomboula/features/home/data/models/participant.dart';
import 'package:tomboula/features/home/data/repositories/participant_repo.dart';

class ParticipantProvider extends StateNotifier<Participant?> {
  ParticipantProvider(this._ref) : super(null);
  final ParticipantRepo _participantRepo = ParticipantRepo();
  final Ref _ref;
  String get token =>
      (_ref.read(loginControllerProvider) as LoginSuccess).token;
  void clear() {
    state = null;
  }

  void prepareParticipant(Participant participant) {
    state = participant;
  }

  Future<bool> isParticipantRegistered(String phone) async {
    try {
      final isRegistered = await _participantRepo.isParticipantRegistered(
          phone: phone, token: token);
      return isRegistered;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addParticipant(String prizeId, String coefficient) async {
    try {
      final participant = state;
      if (participant == null) throw Exception('Participant is null');
      final isAdded = await _participantRepo.addParticipant(
          participant: participant.copyWith(prizeId: prizeId),
          token: token,
          coefficient: coefficient);
      state = null;
      if (!isAdded) throw Exception('Failed to add participant');
    } catch (e) {
      rethrow;
    }
  }
}

final participantProvider =
    StateNotifierProvider<ParticipantProvider, Participant?>((ref) {
  return ParticipantProvider(ref);
});
