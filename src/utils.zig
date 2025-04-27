// Checks if a char is a punctuation acording to ascii table code
// Base reference: https://www.ascii-code.com/
pub fn isPunctuation(c: u8) bool {
    return (c >= 33 and c <= 47) or
        (c >= 58 and c <= 64) or
        (c >= 91 and c <= 96) or
        (c >= 123 and c <= 126);
}

pub fn isIntermediateSymbol(c: u8) bool {
    return c == '-' or c == '\'' or c == '/' or c == '_' or c == '@';
}

pub fn lowercaseCopy(allocator: std.mem.Allocator, text: []const u8) ![]const u8 {
    var buffer = try allocator.alloc(u8, text.len);

    for (text, 0..) |c, i| {
        buffer[i] = std.ascii.toLower(c);
    }

    return buffer;
}

const std = @import("std");
