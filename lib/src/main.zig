const std = @import("std");
const String = @import("./string.zig").String;

const expect = std.testing.expect;
const expectEqualStrings = std.testing.expectEqualStrings;

pub fn main() !void {
    var arena_instance = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_instance.deinit();
    const allocator = arena_instance.allocator();

    var str = try String.init(allocator, "asd asd asd");
    str.println();
    _ = str.concat(" another one");
    str.println();
    _ = str.reverse();
    str.println();
}

test "capitalize" {
    var arena_instance = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_instance.deinit();
    const allocator = arena_instance.allocator();

    const str = try String.init(allocator, "hello Zig.");
    try expectEqualStrings(str.capitalize(), "Hello Zig.");

    const str1 = try String.init(allocator, "a");
    try expectEqualStrings(str1.capitalize(), "A");

    const str2 = try String.init(allocator, "A");
    try expectEqualStrings(str2.capitalize(), "A");

    const str3 = try String.init(allocator, "");
    try expectEqualStrings(str3.capitalize(), "");
}

test "concat" {
    var arena_instance = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_instance.deinit();
    const allocator = arena_instance.allocator();

    var str = try String.init(allocator, "hello");
    try expectEqualStrings(str.concat(" Zig."), "hello Zig.");
    try expect(str.length == 10);

    try expectEqualStrings(str.concat("!!!!!!!!!!!"), "hello Zig.!!!!!!!!!!!");
    try expect(str.length == 21);

    try expectEqualStrings(str.concat(" ☆*: .｡. o(≧▽≦)o .｡.:*☆"), "hello Zig.!!!!!!!!!!! ☆*: .｡. o(≧▽≦)o .｡.:*☆");
    try expect(str.length == 58);
}

test "startsWith" {
    var arena_instance = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_instance.deinit();
    const allocator = arena_instance.allocator();

    var str = try String.init(allocator, "pesho");
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
    var arena_instance = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_instance.deinit();
    const allocator = arena_instance.allocator();

    var str = try String.init(allocator, "pesho");
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
    var arena_instance = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_instance.deinit();
    const allocator = arena_instance.allocator();

    var str = try String.init(allocator, "lebed");
    try expectEqualStrings(str.reverse(), "debel");

    var str1 = try String.init(allocator, "Hello Zig!");
    try expectEqualStrings(str1.reverse(), "!giZ olleH");

    var str2 = try String.init(allocator, "zi");
    try expectEqualStrings(str2.reverse(), "iz");
}

test "includes" {
    var arena_instance = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_instance.deinit();
    const allocator = arena_instance.allocator();

    var str = try String.init(allocator, "pepeshope");
    try expect(str.includes("pesho"));
    try expect(str.includes("pe"));
    try expect(str.includes("ope"));
    try expect(str.includes("shop"));
    try expect(str.includes("shope"));
    try expect(!str.includes("opep"));

    var str1 = try String.init(allocator, "Hello Zig!");
    try expect(str1.includes("!"));
    try expect(str1.includes("Zig!"));
    try expect(str1.includes("ig"));
    try expect(str1.includes("e"));
    try expect(str1.includes("Hello"));
    try expect(!str1.includes("pesho"));
    try expect(!str1.includes("Hhello"));

    var str2 = try String.init(allocator, "x");
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
    var arena_instance = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_instance.deinit();
    const allocator = arena_instance.allocator();

    var str = try String.init(allocator, "pepeshope");
    try expectEqualStrings(str.toUpperCase(), "PEPESHOPE");

    var str1 = try String.init(allocator, "xXxXxX");
    try expectEqualStrings(str1.toUpperCase(), "XXXXXX");

    var str2 = try String.init(allocator, "XX");
    try expectEqualStrings(str2.toUpperCase(), "XX");

    var str3 = try String.init(allocator, "a@!?./adfoigioadf0101hOH0");
    try expectEqualStrings(str3.toUpperCase(), "A@!?./ADFOIGIOADF0101HOH0");
}

test "toLowerCase" {
    var arena_instance = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_instance.deinit();
    const allocator = arena_instance.allocator();

    var str = try String.init(allocator, "PEPESHOPE");
    try expectEqualStrings(str.toLowerCase(), "pepeshope");

    var str1 = try String.init(allocator, "xXxXxX");
    try expectEqualStrings(str1.toLowerCase(), "xxxxxx");

    var str2 = try String.init(allocator, "xx");
    try expectEqualStrings(str2.toLowerCase(), "xx");

    var str3 = try String.init(allocator, "A@!?./ADFOIGIOADF0101HOH0");
    try expectEqualStrings(str3.toLowerCase(), "a@!?./adfoigioadf0101hoh0");
}

test "clear" {
    var arena_instance = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_instance.deinit();
    const allocator = arena_instance.allocator();

    var str = try String.init(allocator, "PEPESHOPE");
    try expect(str.length == 9);

    str.clear();
    try expectEqualStrings(str.buffer, "");
    try expect(str.length == 0);

    var str1 = try String.init(allocator, "xXxXxX");
    try expect(str1.length == 6);

    str1.clear();
    try expectEqualStrings(str1.buffer, "");
    try expect(str1.length == 0);

    var str2 = try String.init(allocator, "xx");
    try expect(str2.length == 2);

    str2.clear();
    try expectEqualStrings(str2.buffer, "");
    try expect(str2.length == 0);

    var str3 = try String.init(allocator, "A@!?./ADFOIGIOADF0101HOH0");
    try expect(str3.length == 25);

    str3.clear();
    try expectEqualStrings(str3.buffer, "");
    try expect(str3.length == 0);
}
