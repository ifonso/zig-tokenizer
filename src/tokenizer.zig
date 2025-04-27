const std = @import("std");
const utils = @import("./utils.zig");

const Token = @import("./types/token.zig").Token;

pub const TokenizerMode = enum {
    Conservative,
    Aggressive,
};

pub const Tokenizer = struct {
    lowercase: bool,
    mode: TokenizerMode = .Conservative,

    pub fn init(lowercase: bool, mode: ?TokenizerMode) Tokenizer {
        if (mode) |m| {
            return Tokenizer{
                .lowercase = lowercase,
                .mode = m,
            };
        } else {
            return Tokenizer{
                .lowercase = lowercase,
            };
        }
    }

    pub fn tokenize(self: *const Tokenizer, allocator: std.mem.Allocator, text: []const u8) !std.ArrayList(Token) {
        var tokens = try std.ArrayList(Token).initCapacity(allocator, 128);
        var i: usize = 0;

        while (i < text.len) {
            // Pula espaços em branco.
            if (std.ascii.isWhitespace(text[i])) {
                i += 1;
                continue;
            }

            if (utils.isPunctuation(text[i])) {
                const token = Token{
                    .slice = text[i .. i + 1],
                    .start_offset = i,
                    .end_offset = i + 1,
                };

                try tokens.append(token);

                i += 1;
                continue;
            }

            // Expande sliding window até obter o range da palavra
            const word_start = i;
            while (i < text.len) {
                if (self.mode == .Aggressive) {
                    if (!utils.isPunctuation(text[i]) and !std.ascii.isWhitespace(text[i])) {
                        i += 1;
                    } else break;
                } else {
                    if (self.shouldContinueConservative(text, i)) {
                        i += 1;
                    } else break;
                }
            }

            const slice = if (self.lowercase) try utils.lowercaseCopy(allocator, text[word_start..i]) else text[word_start..i];

            const token = Token{
                .slice = slice,
                .start_offset = word_start,
                .end_offset = i,
            };

            try tokens.append(token);
        }

        return tokens;
    }

    pub fn shouldContinueConservative(_: *const Tokenizer, text: []const u8, i: usize) bool {
        if (std.ascii.isWhitespace(text[i]))
            return false;

        if (utils.isIntermediateSymbol(text[i])) {
            if (i + 1 >= text.len or std.ascii.isWhitespace(text[i + 1]))
                return false;
        }

        return utils.isIntermediateSymbol(text[i]) == utils.isPunctuation(text[i]);
    }
};
