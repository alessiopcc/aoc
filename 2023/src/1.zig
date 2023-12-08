const std = @import("std");

const input_file = "../input/1.txt";

pub fn main() !void {
    try part_1();
    try part_2();
}

fn part_1() !void {
    const file = try std.fs.cwd().openFile(input_file, .{});
    defer file.close();

    var io_reader = std.io.bufferedReader(file.reader());
    const stream = io_reader.reader();

    var accumulator: usize = 0;

    const ascii_base: comptime_int = 48;

    var l: [1024]u8 = undefined;
    while (try stream.readUntilDelimiterOrEof(&l, '\n')) |line| {
        var first: *u8 = undefined;
        var second: *u8 = undefined;

        var i: usize = 0;
        while (i < line.len) : (i += 1) {
            const c = &line[i];
            if (c.* >= ascii_base and c.* <= ascii_base + 9) {
                first = c;
                break;
            }
        }

        i = line.len - 1;
        while (i >= 0) : (i -= 1) {
            const c = &line[i];
            if (c.* >= ascii_base and c.* <= ascii_base + 9) {
                second = c;
                break;
            }
        }

        accumulator += (first.* - ascii_base) * 10 + (second.* - ascii_base);
    }

    std.log.info("result 1 -> {d}", .{accumulator});
}

fn part_2() !void {
    const file = try std.fs.cwd().openFile(input_file, .{});
    defer file.close();

    var io_reader = std.io.bufferedReader(file.reader());
    const stream = io_reader.reader();

    var accumulator: usize = 0;

    var values = [18][]const u8{ "1", "2", "3", "4", "5", "6", "7", "8", "9", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

    var l: [1024]u8 = undefined;
    while (try stream.readUntilDelimiterOrEof(&l, '\n')) |line| {
        var first: usize = undefined;
        var first_pos: usize = line.len;
        var second: usize = undefined;
        var second_pos: usize = 0;

        for (0.., values) |i, value| {
            var lpos = std.mem.indexOf(u8, line, value);
            var rpos = std.mem.lastIndexOf(u8, line, value);

            if (lpos) |pos| {
                if (pos <= first_pos) {
                    first_pos = pos;
                    first = (i % 9) + 1;
                }
            }

            if (rpos) |pos| {
                if (pos >= second_pos) {
                    second_pos = pos;
                    second = (i % 9) + 1;
                }
            }
        }

        accumulator += first * 10 + second;
    }

    std.log.info("result 2 -> {d}", .{accumulator});
}
