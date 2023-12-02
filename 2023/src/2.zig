const std = @import("std");

const input_file = "../input/2.txt";

pub fn main() !void {
    try part_1();
    try part_2();
}

fn part_1() !void {
    const file = try std.fs.cwd().openFile(input_file, .{});
    defer file.close();

    var io_reader = std.io.bufferedReader(file.reader());
    const stream = io_reader.reader();

    const allocator = std.heap.page_allocator;
    var bag = std.StringHashMap(usize).init(allocator);
    defer bag.deinit();
    try bag.put("red", 12);
    try bag.put("green", 13);
    try bag.put("blue", 14);

    var accumulator: usize = 0;

    var l: [1024]u8 = undefined;
    while (try stream.readUntilDelimiterOrEof(&l, '\n')) |line| {
        var line_iter = std.mem.split(u8, line, ": ");

        var game_biter = std.mem.splitBackwards(u8, line_iter.first(), " ");
        var game_id = try std.fmt.parseInt(usize, game_biter.first(), 10);

        var valid = true;

        var turn_iter = std.mem.split(u8, line_iter.rest(), "; ");
        while (turn_iter.next()) |turn| {
            var cube_iter = std.mem.split(u8, turn, ", ");
            while (cube_iter.next()) |cube| {
                var value_iter = std.mem.split(u8, cube, " ");
                var num = try std.fmt.parseInt(usize, value_iter.first(), 10);
                var color = value_iter.rest();

                if (!bag.contains(color) or num > bag.get(color).?) {
                    valid = false;
                    break;
                }
            }

            if (!valid) {
                break;
            }
        }

        if (valid) {
            accumulator += game_id;
        }
    }

    std.log.info("result 1 -> {d}", .{accumulator});
}

fn part_2() !void {
    const file = try std.fs.cwd().openFile(input_file, .{});
    defer file.close();

    var io_reader = std.io.bufferedReader(file.reader());
    const stream = io_reader.reader();

    const allocator = std.heap.page_allocator;

    var accumulator: usize = 0;

    var l: [1024]u8 = undefined;
    while (try stream.readUntilDelimiterOrEof(&l, '\n')) |line| {
        var line_iter = std.mem.split(u8, line, ": ");
        _ = line_iter.first();

        var bag = std.StringHashMap(usize).init(allocator);
        defer bag.deinit();

        var turn_iter = std.mem.split(u8, line_iter.rest(), "; ");
        while (turn_iter.next()) |turn| {
            var cube_iter = std.mem.split(u8, turn, ", ");
            while (cube_iter.next()) |cube| {
                var value_iter = std.mem.split(u8, cube, " ");
                var num = try std.fmt.parseInt(usize, value_iter.first(), 10);
                var color = value_iter.rest();

                if (!bag.contains(color) or num > bag.get(color).?) {
                    try bag.put(color, num);
                }
            }
        }

        var bag_accumulator: usize = 1;
        var bag_iter = bag.valueIterator();
        while (bag_iter.next()) |value| {
            bag_accumulator *= value.*;
        }

        accumulator += bag_accumulator;
    }

    std.log.info("result 2 -> {d}", .{accumulator});
}
