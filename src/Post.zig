
const Post = @This();

name: []const u8 = "",
title: []const u8 = "Joey Smalen",
description: []const u8 = "Smally's not-so-special blog, usually about little projects",
created: []const u8 = "never",
last_change: []const u8 = "never",
thumbnail: []const u8 = "",
path: []const u8 = "",

pub const posts = [_]Post {
    .{
        .name = "68000",
        .title = "HD68000 breadboard project",
        .description = "The microprocessor ahead of its time",
        .created = "2026-04-12",
        .last_change = "2026-04-12",
        .thumbnail = "posts/m68k/thumbnail.jpg",
        .path = "posts/m68k" },
    .{
        .name = "Assembly",
        .title = "The take on assembly",
        .description = "Scariness of assembly, and different levels of computing systems",
        .created = "2026-03-08",
        .last_change = "2026-03-08",
        .path = "posts/assembly" },
    .{
        .name = "6809",
        .title = "MC6809 breadboard project",
        .description = "some information here",
        .created = "2026-02-04",
        .last_change = "2026-03-02",
        .thumbnail = "posts/6809/thumbnail.jpg",
        .path = "posts/6809" },
    .{
        .name = "Z80",
        .title = "Z84C00 breadboard project",
        .description = "System on a Breadboard (SoB)",
        .created = "2025-12-30",
        .last_change = "2026-03-08",
        .thumbnail = "posts/z80/dma-system.jpg",
        .path = "posts/z80" },
    .{
        .name = "Netrw",
        .title = "Accidentally printing 12 pages of files",
        .description = "How a Netrw default wasted my paper supply",
        .created = "2025-12-28",
        .last_change = "2025-12-28",
        .path = "posts/netrw" },
    .{
        .name = "Vim",
        .title = "Controversy about modern IDEs",
        .description = "My reasons for preferring Vim over 'modern' IDEs",
        .created = "2025-12-23",
        .last_change = "2025-12-23",
        .path = "posts/vim" },
    .{
        .name = "6502",
        .title = "W65C02 breadboard project",
        .description = "System running original Apple I software with UART",
        .created = "2025-12-22",
        .last_change = "2025-12-26",
        .thumbnail = "posts/6502/thumbnail.jpg",
        .path = "posts/6502" }
};
