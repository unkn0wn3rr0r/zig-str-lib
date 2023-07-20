const std = @import("std");
const String = @import("./string.zig").String;

const print = std.debug.print;
const expect = std.testing.expect;
const expectEqualStrings = std.testing.expectEqualStrings;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    const str = String.new(&allocator, "asd");

    print("{}\n", .{@TypeOf("asd"[0.."asd".len].*)});
    print("str.len: {d}\n", .{str.length});
    print("str.string: {s}\n", .{str.string});
    print("str.capitalize: {s}\n", .{str.capitalize()});
    print("str.concat: {s}\n", .{str.concat(" xxx")});
    print("str.len: {d}\n", .{str.length});
}

test "capitalize" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    const str = String.new(&allocator, "hello Zig.");
    try expectEqualStrings(str.capitalize(), "Hello Zig.");

    const str1 = String.new(&allocator, "a");
    try expectEqualStrings(str1.capitalize(), "A");

    const str2 = String.new(&allocator, "A");
    try expectEqualStrings(str2.capitalize(), "A");

    const str3 = String.new(&allocator, "");
    try expectEqualStrings(str3.capitalize(), "");
}
