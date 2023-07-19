const std = @import("std");
const String = @import("./string.zig").String;

const print = std.debug.print;
const expect = std.testing.expect;
const expectEqualStrings = std.testing.expectEqualStrings;

pub fn main() !void {
    const s = "asd";
    const str = String.new(s);

    print("{}\n", .{@TypeOf(s[0..s.len].*)});
    print("str.len: {d}\n", .{str.length});
    print("str.string: {s}\n", .{str.string});
    print("str.capitalize: {s}\n", .{str.capitalize()});
}

test "capitalize" {
    const s = "hello Zig.";
    const str = String.new(s);
    try expectEqualStrings(str.capitalize(), "Hello Zig.");

    const s1 = "a";
    const str1 = String.new(s1);
    try expectEqualStrings(str1.capitalize(), "A");

    const s2 = "A";
    const str2 = String.new(s2);
    try expectEqualStrings(str2.capitalize(), "A");

    const s3 = "";
    const str3 = String.new(s3);
    try expectEqualStrings(str3.capitalize(), "");
}
