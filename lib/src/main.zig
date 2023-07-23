const std = @import("std");
const String = @import("./string.zig").String;

const print = std.debug.print;
const expect = std.testing.expect;
const expectEqualStrings = std.testing.expectEqualStrings;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();
    _ = allocator;

    const foundAt = std.mem.indexOf(u32, &[_]u32{ 1, 2, 3, 5 }, &[_]u32{2});
    print("{}\n", .{foundAt.?});
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

test "includes" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    var str = String.new(&allocator, "pepeshope");
    try expect(str.includes("pesho"));
    try expect(str.includes("pe"));
    try expect(str.includes("ope"));
    try expect(str.includes("shop"));
    try expect(str.includes("shope"));
    try expect(!str.includes("opep"));

    var str1 = String.new(&allocator, "Hello Zig!");
    try expect(str1.includes("!"));
    try expect(str1.includes("Zig!"));
    try expect(str1.includes("ig"));
    try expect(str1.includes("e"));
    try expect(str1.includes("Hello"));
    try expect(!str1.includes("pesho"));
    try expect(!str1.includes("Hhello"));

    var str2 = String.new(&allocator, "x");
    try expect(str2.includes("x"));
    try expect(!str2.includes("!"));
    try expect(!str2.includes("Zig!"));
    try expect(!str2.includes("ig"));
    try expect(!str2.includes("e"));
    try expect(!str2.includes("Hello"));
    try expect(!str2.includes("pesho"));
    try expect(!str2.includes("Hhello"));
}

test "toUpperCase" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    var str = String.new(&allocator, "pepeshope");
    try expectEqualStrings(str.toUpperCase(), "PEPESHOPE");

    var str1 = String.new(&allocator, "xXxXxX");
    try expectEqualStrings(str1.toUpperCase(), "XXXXXX");

    var str2 = String.new(&allocator, "XX");
    try expectEqualStrings(str2.toUpperCase(), "XX");

    var str3 = String.new(&allocator, "a@!?./adfoigioadf0101hOH0");
    try expectEqualStrings(str3.toUpperCase(), "A@!?./ADFOIGIOADF0101HOH0");
}

test "toLowerCase" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    var str = String.new(&allocator, "PEPESHOPE");
    try expectEqualStrings(str.toLowerCase(), "pepeshope");

    var str1 = String.new(&allocator, "xXxXxX");
    try expectEqualStrings(str1.toLowerCase(), "xxxxxx");

    var str2 = String.new(&allocator, "xx");
    try expectEqualStrings(str2.toLowerCase(), "xx");

    var str3 = String.new(&allocator, "A@!?./ADFOIGIOADF0101HOH0");
    try expectEqualStrings(str3.toLowerCase(), "a@!?./adfoigioadf0101hoh0");
}

test "clear" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    var str = String.new(&allocator, "PEPESHOPE");
    str.clear();
    try expectEqualStrings(str.string, "");
    try expect(str.length == 0);

    var str1 = String.new(&allocator, "xXxXxX");
    str1.clear();
    try expectEqualStrings(str1.string, "");
    try expect(str1.length == 0);

    var str2 = String.new(&allocator, "xx");
    str2.clear();
    try expectEqualStrings(str2.string, "");
    try expect(str2.length == 0);

    var str3 = String.new(&allocator, "A@!?./ADFOIGIOADF0101HOH0");
    str3.clear();
    try expectEqualStrings(str3.string, "");
    try expect(str3.length == 0);
}
