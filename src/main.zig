const std = @import("std");
const tokenizer = @import("tokenizer.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = "Yes, it's end-to-end encrypted, top-notch security!";
    const tk = tokenizer.Tokenizer.init(true, .Conservative);

    const tokens = try tk.tokenize(allocator, input);

    for (tokens.items) |token| {
        std.debug.print("[{d}:{d}] '{s}'\n", .{ token.start_offset, token.end_offset, token.slice });
    }
}
