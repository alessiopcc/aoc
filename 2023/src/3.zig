const std = @import("std");

const input_file = "../input/3.txt";

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
    var list = std.ArrayList([]const u8).init(allocator);
    defer list.deinit();

    var accumulator: usize = 0;

    while (try stream.readUntilDelimiterOrEofAlloc(allocator, '\n', 1024)) |line| {
        try list.append(line);
    }

    var number: usize = 0;
    var found = false;

    for (0.., list.items) |i, line| {
        if (found)
            accumulator += number;

        number = 0;
        found = false;

        for (0.., line) |j, char| {
            if (char >= 48 and char <= 57) {
                var first = number == 0;
                number = number * 10 + (char - 48);

                if (!found) {
                    if (i > 0) {
                        if (first) {
                            if (j > 0) {
                                if (is_symbol(list.items[i - 1][j - 1])) {
                                    found = true;
                                    continue;
                                }
                            }
                            if (is_symbol(list.items[i - 1][j])) {
                                found = true;
                                continue;
                            }
                        }
                        if (j < line.len - 1) {
                            if (is_symbol(list.items[i - 1][j + 1])) {
                                found = true;
                                continue;
                            }
                        }
                    }

                    if (first) {
                        if (j > 0) {
                            if (is_symbol(list.items[i][j - 1])) {
                                found = true;
                                continue;
                            }
                        }
                        if (is_symbol(list.items[i][j])) {
                            found = true;
                            continue;
                        }
                    }
                    if (j < line.len - 1) {
                        if (is_symbol(list.items[i][j + 1])) {
                            found = true;
                            continue;
                        }
                    }

                    if (i < list.items.len - 1) {
                        if (first) {
                            if (j > 0) {
                                if (is_symbol(list.items[i + 1][j - 1])) {
                                    found = true;
                                    continue;
                                }
                            }
                            if (is_symbol(list.items[i + 1][j])) {
                                found = true;
                                continue;
                            }
                        }
                        if (j < line.len - 1) {
                            if (is_symbol(list.items[i + 1][j + 1])) {
                                found = true;
                                continue;
                            }
                        }
                    }
                }
            } else {
                if (found)
                    accumulator += number;

                number = 0;
                found = false;
            }
        }
    }

    if (found)
        accumulator += number;

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

fn is_symbol(char: u8) bool {
    if (char == '.')
        return false;

    if (char >= 48 and char <= 57)
        return false;

    return true;
}
