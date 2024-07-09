import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomboula/features/admin/data/repositories/cadeaux_repo.dart';
import 'package:tomboula/features/auth/data/repositories/login_state.dart';
import 'package:tomboula/features/auth/providers/login_controller.dart';
import 'package:tomboula/features/home/data/models/prize.dart';

class CadeauxProvider extends StateNotifier<List<Prize>> {
  CadeauxProvider(this._ref) : super([]);
  final Ref _ref;
  List<Prize> get participants => state;
  CadeauxRepo get _cadeauxRepo => CadeauxRepo();
  String get token => (_ref.read(loginControllerProvider) as LoginSuccess).token;
  void clear() {
    state = [];
  }

  Future<void> fetchCadeaux() async {
    try {
      final participants = await _cadeauxRepo.fetchCadeaux(token: token);
      state = participants;
    } catch (e) {
      rethrow;
    }
  }
  Future<void> updateCadeau({required String id, required String name,required int coefficient}) async {
    try {
      await _cadeauxRepo.updateCadeau(token: token,id: id,name: name,coefficient: coefficient);
      fetchCadeaux();
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> addPrize({required String name,required int coefficient, required XFile image}) async {
    try {
      await _cadeauxRepo.addPrize(token: token,name: name,coefficient: coefficient, image: image);
      fetchCadeaux();
      return true;
    } catch (e) {
      rethrow;
    }
  }

}


final cadeauxProvider = StateNotifierProvider<CadeauxProvider, List<Prize>>((ref) {
  return CadeauxProvider(ref);
});