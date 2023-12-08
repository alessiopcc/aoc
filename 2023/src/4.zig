const std = @import("std");

const input_file = "../input/4.txt";

pub fn main() !void {
    try part_1();
    try part_2();
}

fn part_1() !void {
    const file = try std.fs.cwd().openFile(input_file, .{});
    defer file.close();

    var io_reader = std.io.bufferedReader(file.reader());
    const stream = io_reader.reader();

    var allocator = std.heap.page_allocator;

    var accumulator: usize = 0;

    var l: [1024]u8 = undefined;
    while (try stream.readUntilDelimiterOrEof(&l, '\n')) |line| {
        var line_iter = std.mem.split(u8, line, ": ");
        _ = line_iter.first();

        var card_iter = std.mem.split(u8, line_iter.rest(), "|");

        var winning_list = std.ArrayList(usize).init(allocator);
        defer winning_list.deinit();
        try parse_insert_sorted(&winning_list, card_iter.first());

        var number_list = std.ArrayList(usize).init(allocator);
        defer number_list.deinit();
        try parse_insert_sorted(&number_list, card_iter.rest());

        var winning_count: usize = 0;
        var end = false;

        var i: usize = 0;
        var winning = winning_list.items[i];

        for (number_list.items) |number| {
            while (number > winning) {
                i += 1;

                if (i == winning_list.items.len) {
                    end = true;
                    break;
                }

                winning = winning_list.items[i];
            }

            if (end)
                break;

            if (number == winning) {
                winning_count += 1;
            }
        }

        if (winning_count > 0)
            accumulator += std.math.pow(usize, 2, (winning_count - 1));
    }

    std.log.info("result 1 -> {d}", .{accumulator});
}

fn part_2() !void {
    const file = try std.fs.cwd().openFile(input_file, .{});
    defer file.close();

    var io_reader = std.io.bufferedReader(file.reader());
    const stream = io_reader.reader();

    var allocator = std.heap.page_allocator;
    var map = std.AutoHashMap(usize, usize).init(allocator);
    defer map.deinit();
    var total_cards: usize = 0;

    var accumulator: usize = 0;

    var l: [1024]u8 = undefined;
    while (try stream.readUntilDelimiterOrEof(&l, '\n')) |line| {
        total_cards += 1;
        var line_iter = std.mem.split(u8, line, ": ");

        var card_biter = std.mem.splitBackwards(u8, line_iter.first(), " ");
        var card_id = try std.fmt.parseInt(usize, card_biter.first(), 10);

        var card_iter = std.mem.split(u8, line_iter.rest(), "|");

        var winning_list = std.ArrayList(usize).init(allocator);
        defer winning_list.deinit();
        try parse_insert_sorted(&winning_list, card_iter.first());

        var number_list = std.ArrayList(usize).init(allocator);
        defer number_list.deinit();
        try parse_insert_sorted(&number_list, card_iter.rest());

        var winning_count: usize = 0;
        var end = false;

        var i: usize = 0;
        var winning = winning_list.items[i];

        for (number_list.items) |number| {
            while (number > winning) {
                i += 1;

                if (i == winning_list.items.len) {
                    end = true;
                    break;
                }

                winning = winning_list.items[i];
            }

            if (end)
                break;

            if (number == winning) {
                winning_count += 1;
            }
        }

        if (winning_count > 0) {
            var j: usize = 1;
            var multiplier: usize = 1;

            if (map.contains(card_id))
                multiplier += map.get(card_id).?;

            while (j <= winning_count) : (j += 1) {
                if (!map.contains(card_id + j)) {
                    _ = try map.put(card_id + j, 0);
                }
                try map.put(card_id + j, map.get(card_id + j).? + multiplier);
            }
        }
    }

    accumulator += total_cards;

    var i: usize = 0;
    while (i <= total_cards) : (i += 1) {
        var value = map.get(i);
        if (value) |v| {
            accumulator += v;
        }
    }

    std.log.info("result 2 -> {d}", .{accumulator});
}

fn parse_insert_sorted(list: *std.ArrayList(usize), line: []const u8) !void {
    var iter = std.mem.split(u8, line, " ");
    while (iter.next()) |number| {
        if (number.len == 0)
            continue;

        var num = try std.fmt.parseInt(usize, number, 10);

        var insert = false;

        for (0.., list.*.items) |i, value| {
            if (value > num) {
                try list.*.insert(i, num);
                insert = true;
                break;
            }
        }

        if (!insert)
            try list.*.append(num);
    }
}
