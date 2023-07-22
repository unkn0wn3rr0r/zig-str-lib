const std = @import("std");
const String = @import("./string.zig").String;

const print = std.debug.print;
const expect = std.testing.expect;
const expectEqualStrings = std.testing.expectEqualStrings;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    var str = String.new(&allocator, "asd");

    print("{}\n", .{@TypeOf("asd"[0.."asd".len].*)});
    print("str.len: {d}\n", .{str.length});
    print("str.string: {s}\n", .{str.string});
    print("str.capitalize: {s}\n", .{str.capitalize()});
    print("str.concat: {s}\n", .{str.concat(" xxx")});
    print("str.len: {d}\n", .{str.length});
    print("str.string: {s}\n", .{str.string});
    print("str.concat: {s}\n", .{str.concat("hello Zig.!!!!!!!!!!! ☆*: .｡. o(≧▽≦)o .｡.:*☆")});
    print("str.len: {d}\n", .{str.length});
    print("{s}.endsWith 'sho': {}\n", .{ str.string, str.endsWith("sho") });
    print("{s}.endsWith 'sd': {}\n", .{ str.string, str.endsWith("sd") });
    print("{s}.endsWith 'sd': {}\n", .{ str.string, str.endsWith("☆*: .｡. o(≧▽≦)o .｡.:*☆") });
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
