import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/local_preferences_service.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../incidents/domain/entities/incident.dart';
import '../../../incidents/presentation/providers/incidents_providers.dart';
import '../../../kids/domain/entities/child.dart';
import '../../../kids/presentation/providers/kids_providers.dart';
import '../../../tasks/domain/entities/class_task.dart';
import '../../../tasks/presentation/providers/tasks_providers.dart';

/// Ocorrências e tarefas que a família já abriu neste aparelho. Serve para
/// mostrar "novo" nos cartões dos filhos até a pessoa ir conferir.
class SeenIds extends StateNotifier<Set<String>> {
  SeenIds(this._prefs, this._key)
    : super((_prefs.getStringList(_key) ?? const <String>[]).toSet());

  final SharedPreferences _prefs;
  final String _key;

  void markAll(Iterable<String> ids) {
    final next = {...state, ...ids};
    if (next.length == state.length) return;
    state = next;
    _prefs.setStringList(_key, next.toList());
  }
}

final seenIdsProvider = StateNotifierProvider<SeenIds, Set<String>>((ref) {
  final uid = ref.watch(sessionProvider.select((s) => s.user?.uid)) ?? '';
  return SeenIds(ref.watch(sharedPreferencesProvider), 'seen_news_$uid');
});

/// Só conta como novidade o que é recente: ao instalar esta versão, o
/// histórico antigo não vira uma enxurrada de "novo".
const _freshDays = 14;

/// O que a família ainda não conferiu de um filho.
class ChildNews {
  const ChildNews({this.incidents = const [], this.tasks = const []});

  final List<Incident> incidents;
  final List<ClassTask> tasks;

  int get total => incidents.length + tasks.length;
}

final childNewsProvider = Provider.family<ChildNews, Child>((ref, child) {
  final seen = ref.watch(seenIdsProvider);
  final cutoff = DateTime.now().subtract(const Duration(days: _freshDays));
  bool fresh(String id, String createdAt) {
    final d = DateTime.tryParse(createdAt);
    return d != null && d.isAfter(cutoff) && !seen.contains(id);
  }

  final incidents =
      (ref.watch(incidentsProvider).valueOrNull ?? const <Incident>[])
          .where(
            (i) =>
                (i.childId == child.id ||
                    i.involvedChildIds.contains(child.id)) &&
                fresh(i.id, i.createdAt),
          )
          .toList();
  final tasks =
      (ref.watch(classTasksProvider(child.classId)).valueOrNull ??
              const <ClassTask>[])
          .where((t) => fresh(t.id, t.createdAt))
          .toList();
  return ChildNews(incidents: incidents, tasks: tasks);
});

/// Total de novidades de todos os filhos (bolinha no menu "Meus filhos").
final familyNewsTotalProvider = Provider<int>((ref) {
  final kids = ref.watch(childrenProvider).valueOrNull ?? const <Child>[];
  var n = 0;
  for (final c in kids.where((c) => c.active)) {
    n += ref.watch(childNewsProvider(c)).total;
  }
  return n;
});
