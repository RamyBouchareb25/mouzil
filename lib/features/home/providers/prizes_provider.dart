import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomboula/features/auth/data/repositories/login_state.dart';
import 'package:tomboula/features/auth/providers/login_controller.dart';
import 'package:tomboula/features/home/data/models/prize.dart';
import 'package:tomboula/features/home/data/repositories/prizes_repo.dart';

class PrizesProvider extends StateNotifier<List<Prize>> {
  PrizesProvider(this._ref) : super([]);
  final Ref _ref;
  List<Prize> get prizes => state;
  final PrizesRepo _prizesRepo = PrizesRepo();
  String get token => (_ref.read(loginControllerProvider) as LoginSuccess).token;
  void clear() {
    state = [];
  }

  Future<void> fetchPrizes() async {
    try {
      final prizes = await _prizesRepo.fetchPrizes(token: token);
      state = prizes;
    } catch (e) {
      rethrow;
    }
  }
}

final prizesProvider = StateNotifierProvider<PrizesProvider, List<Prize>>((ref) {
  return PrizesProvider(ref);
});