test {
    // NOTE: test subjects must be referenced through the shared `bun` module,
    // not via relative imports. Relative imports would place files that are
    // also reachable via `bun.zig` in two modules, which Zig rejects with
    // "file exists in modules 'root' and 'root'" (dominikake/bun#54).
    _ = @import("bun").shell.interpret.Braces;
    _ = @import("bun").myers_diff;
    // NOTE: `MiniEventLoop` is intentionally not referenced here yet.
    // Demanding it (via any path) trips a pre-existing `dependency loop`
    // between `jsc/event_loop.zig` (`tasks: Queue` → `LinearFifo(Task)`) and
    // `jsc/Task.zig` (a union member chain leading back into `jsc.EventLoop`),
    // which the main binary avoids via dynamic dispatch. That layering issue
    // needs its own fix before the MiniEventLoop unit tests can run in this
    // harness; until then they are covered by `bun bd test` JS-level suites.
}

test "basic string usage" {
    var s = bun.String.cloneUTF8("hi");
    defer s.deref();
    try t.expect(s.tag != .Dead and s.tag != .Empty);
    try t.expectEqual(s.length(), 2);
    try t.expectEqualStrings(s.asUTF8().?, "hi");
}

const bun = @import("bun");

const std = @import("std");
const t = std.testing;
