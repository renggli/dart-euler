import 'dart:collection';
import 'dart:io';

import 'package:more/more.dart';

class Module {
  Module(this.name, this.outgoing);

  final String name;
  final List<String> outgoing;
}

class FlipFlop extends Module {
  FlipFlop(super.name, super.outgoing);

  bool state = false;
}

class Conjunction extends Module {
  Conjunction(super.name, super.outgoing);

  final Map<String, bool> states = {};
}

final modules = File('lib/aoc/2023/dec_20.txt')
    .readAsLinesSync()
    .map((line) {
      final name = line.takeTo(' -> ').removePrefix(CharMatcher.charSet('%&'));
      final outgoing = line.skipTo(' -> ').split(', ');
      final module = line.startsWith('%')
          ? FlipFlop(name, outgoing)
          : line.startsWith('&')
          ? Conjunction(name, outgoing)
          : Module(name, outgoing);
      return MapEntry(name, module);
    })
    .also(Map.fromEntries)
    .also((modules) {
      for (final source in modules.values) {
        for (final target in source.outgoing.map((name) => modules[name])) {
          if (target is Conjunction) {
            target.states[source.name] = false;
          }
        }
      }
      return modules;
    });

final broadcaster = modules['broadcaster']!;
final rx =
    modules.values.singleWhere((each) => each.outgoing.contains('rx'))
        as Conjunction;

var lowCount = 0, highCount = 0, pressCount = 0;
final rxPresses = <String, int>{};

void press() {
  // Initialize the presses.
  lowCount++;
  lowCount += modules['broadcaster']!.outgoing.length;
  pressCount++;

  // Populate the queue with the starting states.
  final queue = ListQueue<(bool, String, String)>();
  for (final target in broadcaster.outgoing) {
    queue.add((false, broadcaster.name, target));
  }

  // Propagate all signals.
  while (queue.isNotEmpty) {
    final (incomingSignal, sourceName, targetName) = queue.removeFirst();
    final targetModule = modules[targetName];
    var outgoingSignal = false;

    // Ignore incoming signals to the RX module.
    if (targetModule == null) {
      assert(targetName == 'rx');
      continue;
    }

    // Flip-flop.
    if (targetModule is FlipFlop) {
      if (incomingSignal) continue;
      targetModule.state = !targetModule.state;
      outgoingSignal = targetModule.state;
    }
    // Conjunction.
    else if (targetModule is Conjunction) {
      targetModule.states[sourceName] = incomingSignal;
      outgoingSignal = !targetModule.states.values.every((each) => each);
    }

    // Count stuff.
    if (outgoingSignal) {
      highCount += targetModule.outgoing.length;
    } else {
      lowCount += targetModule.outgoing.length;
    }

    // Propagate outgoing.
    for (final outgoingName in targetModule.outgoing) {
      queue.add((outgoingSignal, targetName, outgoingName));
    }

    // Record the number of presses after rx input became high the first time.
    for (final MapEntry(key: name, value: state) in rx.states.entries) {
      if (!rxPresses.containsKey(name) && state) {
        rxPresses[name] = pressCount;
      }
    }
  }
}

void main() {
  // Part 1: press a thousand times.
  for (var i = 0; i < 1000; i++) {
    press();
  }
  assert(lowCount * highCount == 886347020);

  // Part 2: continue pressing until we had a signal on all rx inputs.
  while (rxPresses.length < rx.states.length) {
    press();
  }
  assert(rxPresses.values.lcm() == 233283622908263);
}
