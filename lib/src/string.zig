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

    pub fn equals(self: Self, other: []const u8) bool {
        if (self.length != other.len) return false;
        if (self.buffer.ptr == other.ptr) return true;
        for (self.buffer, other) |char_one, char_two| {
            if (char_one != char_two) return false;
        }
        return true;
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
        self.buffer = self.allocator.realloc(self.buffer, new_size) catch unreachable;

        for (input_buffer, 0..) |b, i| {
            self.buffer[i + self.length] = b;
        }
        self.length = new_size;

        return self.buffer;
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
        var start: usize = 0;
        var end: usize = self.length - 1;
        const size = @divFloor(self.length, 2);
        while (start < size) {
            self.swap(start, end);
            start += 1;
            end -= 1;
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

    fn swap(self: Self, start_idx: usize, end_idx: usize) void {
        const first = self.buffer[start_idx];
        const last = self.buffer[end_idx];
        self.buffer[start_idx] = last;
        self.buffer[end_idx] = first;
    }
};
