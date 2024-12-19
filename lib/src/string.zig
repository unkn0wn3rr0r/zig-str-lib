const std = @import("std");
const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub const String = struct {
    const Self = @This();

    allocator: Allocator,
    buffer: []u8,
    length: usize,

    pub fn init(allocator: Allocator, input_buffer: []const u8) !Self {
        return Self{
            .allocator = allocator,
            .buffer = try allocator.dupe(u8, input_buffer),
            .length = input_buffer.len,
        };
    }

    pub fn deinit(self: *Self) void {
        self.allocator.free(self.buffer);
        self.length = 0; // that might be pointless at this point, but anyways..
    }

    pub fn capitalize(self: Self) []const u8 {
        if (self.length < 1) {
            return "";
        }
        if (self.buffer[0] >= 97 and self.buffer[0] <= 122) {
            self.buffer[0] -= 32;
        }
        return self.buffer;
    }

    pub fn concat(self: *Self, input_buffer: []const u8) []const u8 {
        const new_size = self.length + input_buffer.len;
        var new_string: []u8 = self.allocator.alloc(u8, new_size) catch unreachable;

        var i: usize = 0;
        while (i < self.length) : (i += 1) {
            new_string[i] = self.buffer[i];
        }

        var j: usize = 0;
        while (j < input_buffer.len) : (j += 1) {
            new_string[j + i] = input_buffer[j];
        }

        self.length = new_size;
        self.buffer = new_string;

        return new_string;
    }

    pub fn startsWith(self: Self, input_buffer: []const u8) bool {
        if (input_buffer.len > self.length) {
            return false;
        }
        var i: usize = 0;
        while (i < input_buffer.len) : (i += 1) {
            if (input_buffer[i] != self.buffer[i]) {
                return false;
            }
        }
        return true;
    }

    pub fn endsWith(self: Self, input_buffer: []const u8) bool {
        if (input_buffer.len > self.length) {
            return false;
        }
        var i: usize = self.buffer.len - input_buffer.len;
        var t: usize = 0;
        while (i < self.buffer.len) : (i += 1) {
            if (input_buffer[t] != self.buffer[i]) {
                return false;
            }
            t += 1;
        }
        return true;
    }

    pub fn reverse(self: Self) void {
        var reversed: []u8 = self.allocator.alloc(u8, self.length) catch unreachable;
        defer self.allocator.free(reversed);

        var i: usize = 0;
        while (i < self.length) : (i += 1) {
            reversed[i] = self.buffer[self.length - 1 - i];
        }

        i = 0;
        for (reversed) |b| {
            self.buffer[i] = b;
            i += 1;
        }
    }

    pub fn includes(self: Self, input_buffer: []const u8) bool {
        if (input_buffer.len > self.length) {
            return false;
        }
        var i: usize = 0;
        var t: usize = 0;
        while (i < self.length) : (i += 1) {
            if (self.buffer[i] == input_buffer[t]) {
                t += 1;
                if (t == input_buffer.len) {
                    return true;
                }
            } else {
                t = 0;
                if (self.buffer[i] == input_buffer[0] and i > 0) {
                    i -= 1;
                }
            }
        }
        return false;
    }

    pub fn toUpperCase(self: Self) []const u8 {
        var i: usize = 0;
        while (i < self.length) : (i += 1) {
            if (self.buffer[i] >= 97 and self.buffer[i] <= 122) {
                self.buffer[i] -= 32;
            }
        }
        return self.buffer;
    }

    pub fn toLowerCase(self: Self) []const u8 {
        var i: usize = 0;
        while (i < self.length) : (i += 1) {
            if (self.buffer[i] >= 65 and self.buffer[i] <= 90) {
                self.buffer[i] += 32;
            }
        }
        return self.buffer;
    }

    pub fn reset(self: *Self) void {
        self.buffer = "";
        self.length = 0;
    }

    pub fn println(self: Self) void {
        print("{s}\n", .{self.buffer});
    }
};
