const std = @import("std");

const Allocator = std.mem.Allocator;

pub const String = struct {
    const Self = @This();

    string: []u8,
    length: u64,

    pub fn new(str: []const u8) Self {
        return Self{
            .string = copyConstU8ToU8(&std.heap.page_allocator, str), // destroy/free allocator?
            .length = str.len,
        };
    }

    pub fn capitalize(self: Self) []u8 {
        if (self.length < 1) {
            return "";
        }
        if (self.string[0] >= 97 and self.string[0] <= 122) {
            self.string[0] -= 32;
        }
        return self.string;
    }

    fn copyConstU8ToU8(allocator: *const Allocator, str: []const u8) []u8 {
        var buf: []u8 = allocator.alloc(u8, str.len) catch unreachable;
        for (str, 0..) |_, i| {
            buf[i] = str[i];
        }
        return buf;
    }
};
