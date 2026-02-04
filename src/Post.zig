
const Post = @This();

name: []const u8 = "",
title: []const u8 = "Joey Smalen",
description: []const u8 = "Smally's not-so-special blog, usually about little projects",
last_change: []const u8 = "never",
thumbnail: []const u8 = "",
path: []const u8 = "",

pub const posts = [_]Post {
    .{
        .name = "6809",
        .title = "MC6809 breadboard project",
        .description = "some information here",
        .last_change = "2026-02-04",
        .path = "posts/6809" },
    .{
        .name = "Z80",
        .title = "Z84C00 breadboard project",
        .description = "System on a Breadboard (SoB)",
        .last_change = "2026-01-15",
        .thumbnail = "posts/z80/thumbnail.jpg",
        .path = "posts/z80" },
    .{
        .name = "6502",
        .title = "W65C02 breadboard project",
        .description = "Machine running the Apple I software through UART",
        .last_change = "2025-12-26",
        .thumbnail = "posts/6502/thumbnail.jpg",
        .path = "posts/6502" },
    .{
        .name = "Netrw",
        .title = "Accidentally printing 12 pages of files",
        .description = "How a Netrw default wasted my paper supply",
        .last_change = "2025-12-28",
        .path = "posts/netrw" },
    .{
        .name = "Vim",
        .title = "Controversy about modern IDEs",
        .description = "My reasons for preferring Vim over 'modern' IDEs",
        .last_change = "2025-12-23",
        .path = "posts/vim" }
};
