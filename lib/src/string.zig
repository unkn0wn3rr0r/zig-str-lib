const std = @import("std");

const Allocator = std.mem.Allocator;

pub const String = struct {
    const Self = @This();

    allocator: *Allocator,
    string: []u8,
    length: u64,

    pub fn new(allocator: *Allocator, str: []const u8) Self {
        return Self{
            .allocator = allocator,
            .string = copyConstU8ToU8(allocator, str),
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

    pub fn concat(self: *Self, str: []const u8) []const u8 {
        const newSize = self.length + str.len;
        var newString: []u8 = self.allocator.alloc(u8, newSize) catch unreachable;

        var i: usize = 0;
        while (i < self.length) : (i += 1) {
            newString[i] = self.string[i];
        }

        var j: usize = 0;
        while (j < str.len) : (j += 1) {
            newString[j + i] = str[j];
        }

        self.length = newSize;
        self.string = newString;

        return newString;
    }

    pub fn endsWith(self: Self, str: []const u8) bool {
        if (str.len > self.length) {
            return false;
        }
        var i: usize = self.string.len - str.len;
        var t: usize = 0;
        while (i < self.string.len) : (i += 1) {
            if (str[t] != self.string[i]) {
                return false;
            }
            t += 1;
        }
        return true;
    }

    fn copyConstU8ToU8(allocator: *Allocator, str: []const u8) []u8 {
        var buf: []u8 = allocator.alloc(u8, str.len) catch unreachable;
        for (str, 0..) |_, i| {
            buf[i] = str[i];
        }
        return buf;
    }
};
