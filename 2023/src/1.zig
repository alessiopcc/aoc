const std = @import("std");

pub fn main() !void {
    const file = try std.fs.cwd().openFile("../input/1.txt", .{});
    defer file.close();

    var io_reader = std.io.bufferedReader(file.reader());
    const stream = io_reader.reader();

    var accumulator: usize = 0;

    const ansi_base: comptime_int = 48;

    var l: [1024]u8 = undefined;
    while (try stream.readUntilDelimiterOrEof(&l, '\n')) |line| {
        var first: *u8 = undefined;
        var second: *u8 = undefined;

        var i: usize = 0;
        while (i < line.len) : (i += 1) {
            const c = &line[i];
            if (c.* >= ansi_base and c.* <= ansi_base + 9) {
                first = c;
                break;
            }
        }

        i = line.len - 1;
        while (i >= 0) : (i -= 1) {
            const c = &line[i];
            if (c.* >= ansi_base and c.* <= ansi_base + 9) {
                second = c;
                break;
            }
        }

        accumulator += (first.* - ansi_base) * 10 + (second.* - ansi_base);
    }

    std.log.info("result part 1 -> {d}\n", .{accumulator});
}
