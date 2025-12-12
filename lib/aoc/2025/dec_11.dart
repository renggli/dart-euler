import '../../utils.dart';

class AoC2025Day11 extends AoC {
  AoC2025Day11()
    : super(
        year: 2025,
        day: 11,
        part1: 772,
        part2: 423227545768872,
        examples: [
          AoCExample(
            input: [
              'aaa: you hhh',
              'you: bbb ccc',
              'bbb: ddd eee',
              'ccc: ddd eee fff',
              'ddd: ggg',
              'eee: out',
              'fff: out',
              'ggg: out',
              'hhh: ccc fff iii',
              'iii: out',
            ].join('\n'),
            part1: 5,
          ),
          AoCExample(
            input: [
              'svr: aaa bbb',
              'aaa: fft',
              'fft: ccc',
              'bbb: tty',
              'tty: ccc',
              'ccc: ddd eee',
              'ddd: hub',
              'hub: fff',
              'eee: dac',
              'dac: fff',
              'fff: ggg hhh',
              'ggg: out',
              'hhh: out',
            ].join('\n'),
            part2: 2,
          ),
        ],
      );

  Map<String, List<String>> parseData(List<String> input) {
    final graph = <String, List<String>>{};
    for (final line in input) {
      final parts = line.split(': ');
      graph[parts[0]] = parts[1].split(' ');
    }
    return graph;
  }

  int countPaths(
    Map<String, List<String>> graph,
    String source,
    String target, [
    Map<String, int>? cache,
  ]) {
    if (source == target) return 1;
    if ((cache ??= {})[source] case final count?) return count;
    return cache[source] = (graph[source] ?? [])
        .map((neighbor) => countPaths(graph, neighbor, target, cache))
        .fold(0, (a, b) => a + b);
  }

  @override
  int part1(String input) =>
      countPaths(parseData(input.split('\n')), 'you', 'out');

  @override
  int part2(String input) {
    final graph = parseData(input.split('\n'));
    final path1 =
        countPaths(graph, 'svr', 'dac') *
        countPaths(graph, 'dac', 'fft') *
        countPaths(graph, 'fft', 'out');
    final path2 =
        countPaths(graph, 'svr', 'fft') *
        countPaths(graph, 'fft', 'dac') *
        countPaths(graph, 'dac', 'out');
    return path1 + path2;
  }
}

void main() => MainRunner().runProblem(AoC2025Day11());
