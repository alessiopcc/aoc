const std = @import("std");

const input_file = "../input/3.txt";

pub fn main() !void {
    try part_1();
    try part_2();
}

const ascii_n_base: comptime_int = 48;

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
            if (is_number(char)) {
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

const Value = struct {
    id: usize,
    value: usize,
};

fn part_2() !void {
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

    for (0.., list.items) |i, line| {
        for (0.., line) |j, char| {
            if (char == '*') {
                var count: usize = 0;
                var partial: usize = 1;
                if (i > 0) {
                    var line_value: Value = undefined;
                    if (j > 0) {
                        if (is_number(list.items[i - 1][j - 1])) {
                            var value = detect_value(list.items[i - 1], j - 1);
                            if (line_value.id != value.id) {
                                line_value = value;
                                partial *= value.value;
                                count += 1;
                            }
                        }
                    }
                    if (is_number(list.items[i - 1][j])) {
                        var value = detect_value(list.items[i - 1], j);
                        if (line_value.id != value.id) {
                            line_value = value;
                            partial *= value.value;
                            count += 1;
                        }
                    }
                    if (j < line.len - 1) {
                        if (is_number(list.items[i - 1][j + 1])) {
                            var value = detect_value(list.items[i - 1], j + 1);
                            if (line_value.id != value.id) {
                                line_value = value;
                                partial *= value.value;
                                count += 1;
                            }
                        }
                    }
                }

                if (j > 0) {
                    if (is_number(list.items[i][j - 1])) {
                        var value = detect_value(list.items[i], j - 1);
                        partial *= value.value;
                        count += 1;
                    }
                }
                if (j < line.len - 1) {
                    if (is_number(list.items[i][j + 1])) {
                        var value = detect_value(list.items[i], j + 1);
                        partial *= value.value;
                        count += 1;
                    }
                }

                if (i < list.items.len - 1) {
                    var line_value: Value = undefined;
                    if (j > 0) {
                        if (is_number(list.items[i + 1][j - 1])) {
                            var value = detect_value(list.items[i + 1], j - 1);
                            if (line_value.id != value.id) {
                                line_value = value;
                                partial *= value.value;
                                count += 1;
                            }
                        }
                    }
                    if (is_number(list.items[i + 1][j])) {
                        var value = detect_value(list.items[i + 1], j);
                        if (line_value.id != value.id) {
                            line_value = value;
                            partial *= value.value;
                            count += 1;
                        }
                    }
                    if (j < line.len - 1) {
                        if (is_number(list.items[i + 1][j + 1])) {
                            var value = detect_value(list.items[i + 1], j + 1);
                            if (line_value.id != value.id) {
                                line_value = value;
                                partial *= value.value;
                                count += 1;
                            }
                        }
                    }
                }

                if (count == 2)
                    accumulator += partial;
            }
        }
    }

    std.log.info("result 2 -> {d}", .{accumulator});
}

fn is_number(char: u8) bool {
    if (char >= ascii_n_base and char <= ascii_n_base + 9)
        return true;
    return false;
}

fn is_symbol(char: u8) bool {
    if (char == '.')
        return false;

    if (is_number(char))
        return false;

    return true;
}

fn detect_value(line: []const u8, pos: usize) Value {
    var id = pos;

    var i = pos - 1;
    while (i >= 0) : (i -= 1) {
        if (is_number(line[i])) {
            id = i;
        } else break;

        if (i == 0) break;
    }

    return Value{
        .id = id,
        .value = calculate_value(line, id),
    };
}

fn calculate_value(line: []const u8, start: usize) usize {
    var accumulator: usize = 0;

    var i = start;
    while (i < line.len and is_number(line[i])) : (i += 1) {
        accumulator = accumulator * 10 + (line[i] - ascii_n_base);
    }

    return accumulator;
}
