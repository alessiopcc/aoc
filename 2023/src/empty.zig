const std = @import("std");

const input_file = "../input/empty.txt";

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

    var l: [1024]u8 = undefined;
    while (try stream.readUntilDelimiterOrEof(&l, '\n')) |line| {
        _ = line;
    }

    std.log.info("result 1 -> {d}", .{accumulator});
}

fn part_2() !void {
    const file = try std.fs.cwd().openFile(input_file, .{});
    defer file.close();

    var io_reader = std.io.bufferedReader(file.reader());
    const stream = io_reader.reader();

    var accumulator: usize = 0;

    var l: [1024]u8 = undefined;
    while (try stream.readUntilDelimiterOrEof(&l, '\n')) |line| {
        _ = line;
    }

    std.log.info("result 2 -> {d}", .{accumulator});
}
