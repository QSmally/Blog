
const std = @import("std");
const zmpl = @import("zmpl");

const Post = @import("Post.zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const gpa = init.gpa;
    const arena = init.arena.allocator();
    const cwd = std.Io.Dir.cwd();

    const viewport = zmpl.find("viewport") orelse @panic("viewport not found");
    const adapter = zmpl.find("post") orelse @panic("post not found");

    // index is a template itself
    try generate_index(arena, io, cwd, viewport);

    // posts are viewport contents
    for (&Post.posts) |post| {
        const input_path = try std.fmt.allocPrint(arena, "{s}/index.zmpl.html", .{ post.path });
        const output_path = try std.fmt.allocPrint(arena, "{s}/index.html", .{ post.path });

        var file = try cwd.openFile(io, input_path, .{});
        defer file.close(io);

        var reader = file.reader(io, &.{});
        const content = try reader.interface.allocRemaining(gpa, @enumFromInt(4 * 8192));
        defer gpa.free(content);

        var data = zmpl.Data.init(io, arena);
        var body = try data.object();
        try body.put("content", data.string(content));

        const gen_post = try adapter.render(io, &data, Post, post, &.{}, .{ .layout = viewport });
        try cwd.writeFile(io, .{ .sub_path = output_path, .data = gen_post });
    }
}

fn generate_index(
    allocator: std.mem.Allocator,
    io: std.Io,
    pwd: std.Io.Dir,
    viewport: zmpl.Template
) !void {
    var data = zmpl.Data.init(io, allocator);
    var body = try data.object();

    var posts = try data.array();
    for (&Post.posts) |post| try posts.append(post);
    try body.put("posts", posts);

    const index = zmpl.find("index") orelse @panic("index not found");
    const gen_index = try index.render(io, &data, Post, .{}, &.{}, .{ .layout = viewport });
    try pwd.writeFile(io, .{ .sub_path = "index.html", .data = gen_index });
}
