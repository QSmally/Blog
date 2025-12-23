
const Post = @This();

name: []const u8 = "",
title: []const u8 = "Joey Smalen",
description: []const u8 = "Smally's not-so-special blog, usually about little projects",
last_change: []const u8 = "never",
thumbnail: []const u8 = "",
path: []const u8 = "",

pub const posts = [_]Post {
    .{
        .name = "Z80",
        .title = "Z84C00 breadboard project",
        .description = "some information here",
        .last_change = "2025-12-23",
        .thumbnail = "posts/z80/thumbnail.jpg",
        .path = "posts/z80" },
    .{
        .name = "6502",
        .title = "W65C02 breadboard project",
        .description = "some information here",
        .last_change = "2025-12-23",
        .thumbnail = "posts/6502/thumbnail.jpg",
        .path = "posts/6502" }
};
