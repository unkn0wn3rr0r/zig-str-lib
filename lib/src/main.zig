const std = @import("std");
const String = @import("./string.zig").String;

const print = std.debug.print;
const expect = std.testing.expect;
const expectEqualStrings = std.testing.expectEqualStrings;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    var str = String.new(&allocator, "debel");

    print("'{s}' reversed is '{s}'\n", .{ str.string, str.reverse() });
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

test "concat" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    var str = String.new(&allocator, "hello");
    try expectEqualStrings(str.concat(" Zig."), "hello Zig.");
    try expect(str.length == 10);

    try expectEqualStrings(str.concat("!!!!!!!!!!!"), "hello Zig.!!!!!!!!!!!");
    try expect(str.length == 21);

    try expectEqualStrings(str.concat(" ☆*: .｡. o(≧▽≦)o .｡.:*☆"), "hello Zig.!!!!!!!!!!! ☆*: .｡. o(≧▽≦)o .｡.:*☆");
    try expect(str.length == 58);
}

test "startsWith" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    var str = String.new(&allocator, "pesho");
    try expect(str.startsWith("p"));
    try expect(str.startsWith("pe"));
    try expect(str.startsWith("pes"));
    try expect(str.startsWith("pesh"));
    try expect(str.startsWith("pesho"));
    try expect(!str.startsWith("xxx"));
    try expect(!str.startsWith("peshoo"));
    try expect(!str.startsWith("pa"));
    try expect(!str.startsWith("pas"));
}

test "endsWith" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    var str = String.new(&allocator, "pesho");
    try expect(str.endsWith("o"));
    try expect(str.endsWith("ho"));
    try expect(str.endsWith("sho"));
    try expect(str.endsWith("esho"));
    try expect(str.endsWith("pesho"));
    try expect(!str.endsWith("xxx"));
    try expect(!str.endsWith("peshoo"));
    try expect(!str.endsWith("so"));
    try expect(!str.endsWith("cho"));
}

test "reverse" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    var str = String.new(&allocator, "lebed");
    try expectEqualStrings(str.reverse(), "debel");

    var str1 = String.new(&allocator, "Hello Zig!");
    try expectEqualStrings(str1.reverse(), "!giZ olleH");

    var str2 = String.new(&allocator, "zi");
    try expectEqualStrings(str2.reverse(), "iz");
}
