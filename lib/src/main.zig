const std = @import("std");
const String = @import("./string.zig").String;

const print = std.debug.print;
const expect = std.testing.expect;
const expectEqualStrings = std.testing.expectEqualStrings;

pub fn main() !void {
    // var arena_instance = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena_instance.deinit();
    // const allocator = arena_instance.allocator();

    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    defer {
        switch (gpa.deinit()) {
            .ok => print("GPA freed successfully.\n", .{}),
            .leak => print("Leaked memory.\n", .{}),
        }
    }
    const allocator = gpa.allocator();

    var str = try String.init(allocator, "asd asd asd");
    defer str.deinit();

    str.println();
    _ = str.concat(" another one");
    str.println();
    str.reverse();
    str.println();

    var are_eql = str.equals("eno rehtona dsa dsa dsa");
    print("'{s}' = '{s}' -> {}\n", .{ str.buffer, "eno rehtona dsa dsa dsa", are_eql });

    are_eql = str.equals("enu rehtona dsa dsa dsa");
    print("'{s}' = '{s}' -> {}\n", .{ str.buffer, "enu rehtona dsa dsa dsa", are_eql });

    print("str buffer={s}\n", .{str.buffer});
    print("str length={d}\n", .{str.length});

    var list = std.ArrayList(String).init(allocator);
    defer {
        for (list.items) |*s| {
            s.deinit();
        }
        list.deinit();
    }

    const string_arr = [_][]const u8{ "one", "two", "three", "four", "five" };
    for (string_arr) |s| {
        try list.append(try String.init(allocator, s));
    }

    for (list.items, 0..) |s, i| {
        std.debug.print("{d}. {s}\n", .{ i + 1, s.buffer });
    }
}

test "equals" {
    var str = try String.init(std.testing.allocator, "hello Zig.");
    defer str.deinit();
    try expect(str.equals("hello Zig."));
    try expect(!str.equals("Hello Zig."));

    var str1 = try String.init(std.testing.allocator, "a");
    defer str1.deinit();
    try expect(str1.equals("a"));
    try expect(!str1.equals("A"));

    var str2 = try String.init(std.testing.allocator, "1 2 3");
    defer str2.deinit();
    try expect(str2.equals("1 2 3"));
    try expect(!str2.equals("1  2  3"));

    var str3 = try String.init(std.testing.allocator, "string^to@compare");
    defer str3.deinit();
    try expect(str3.equals("string^to@compare"));
    try expect(str3.equals(str3.buffer));
}

test "capitalize" {
    var str = try String.init(std.testing.allocator, "hello Zig.");
    defer str.deinit();
    try expectEqualStrings(str.capitalize(), "Hello Zig.");

    var str1 = try String.init(std.testing.allocator, "a");
    defer str1.deinit();
    try expectEqualStrings(str1.capitalize(), "A");

    var str2 = try String.init(std.testing.allocator, "A");
    defer str2.deinit();
    try expectEqualStrings(str2.capitalize(), "A");

    var str3 = try String.init(std.testing.allocator, "");
    defer str3.deinit();
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
    try expect(!str.endsWith("oo"));
    try expect(!str.endsWith("x"));
}

test "reverse" {
    var arena_instance = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_instance.deinit();
    const allocator = arena_instance.allocator();

    var str = try String.init(allocator, "lebed");
    str.reverse();
    try expectEqualStrings(str.buffer, "debel");

    var str1 = try String.init(allocator, "Hello Zig!");
    str1.reverse();
    try expectEqualStrings(str1.buffer, "!giZ olleH");

    var str2 = try String.init(allocator, "zi");
    str2.reverse();
    try expectEqualStrings(str2.buffer, "iz");

    var str3 = try String.init(allocator, "abcdefg");
    str3.reverse();
    try expectEqualStrings(str3.buffer, "gfedcba");
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

test "reset" {
    var arena_instance = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_instance.deinit();
    const allocator = arena_instance.allocator();

    var str = try String.init(allocator, "PEPESHOPE");
    try expect(str.length == 9);

    str.reset();
    try expectEqualStrings(str.buffer, "");
    try expect(str.length == 0);

    var str1 = try String.init(allocator, "xXxXxX");
    try expect(str1.length == 6);

    str1.reset();
    try expectEqualStrings(str1.buffer, "");
    try expect(str1.length == 0);

    var str2 = try String.init(allocator, "xx");
    try expect(str2.length == 2);

    str2.reset();
    try expectEqualStrings(str2.buffer, "");
    try expect(str2.length == 0);

    var str3 = try String.init(allocator, "A@!?./ADFOIGIOADF0101HOH0");
    try expect(str3.length == 25);

    str3.reset();
    try expectEqualStrings(str3.buffer, "");
    try expect(str3.length == 0);
}
