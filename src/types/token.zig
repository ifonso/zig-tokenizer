const std = @import("std");

pub const Token = struct {
    slice: []const u8,
    start_offset: usize,
    end_offset: usize,
    token_type: TokenType = .Word,
};

const TokenType = enum {
    Word,
    LeadingSubword,
    TrailingSubword,
};
