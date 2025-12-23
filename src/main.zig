
const std = @import("std");
const zmpl = @import("zmpl");

const Post = @import("Post.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}) {};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    const allocator = arena.allocator();
    defer arena.deinit();

    const cwd = std.fs.cwd();

    const viewport = zmpl.find("viewport") orelse @panic("viewport not found");
    const adapter = zmpl.find("post") orelse @panic("post not found");

    // index is a template itself
    try generate_index(allocator, cwd, viewport);

    // posts are viewport contents
    for (&Post.posts) |post| {
        const input_path = try std.fmt.allocPrint(allocator, "{s}/index.zmpl.html", .{ post.path });
        var file = try cwd.openFile(input_path, .{});
        defer file.close();
        const content = try file.readToEndAlloc(allocator, 4 * 8192);
        defer allocator.free(content);

        var data = zmpl.Data.init(allocator);
        var body = try data.object();
        try body.put("content", data.string(content));

        const output_path = try std.fmt.allocPrint(allocator, "{s}/index.html", .{ post.path });
        const gen_post = try adapter.render(&data, Post, post, .{ .layout = viewport });
        try cwd.writeFile(.{ .sub_path = output_path, .data = gen_post });
    }
}

fn generate_index(allocator: std.mem.Allocator, cwd: std.fs.Dir, viewport: zmpl.Template) !void {
    var data = zmpl.Data.init(allocator);
    var body = try data.object();

    var posts = try data.array();
    for (&Post.posts) |post| try posts.append(post);
    try body.put("posts", posts);

    const index = zmpl.find("index") orelse @panic("index not found");
    const gen_index = try index.render(&data, Post, .{}, .{ .layout = viewport });
    try cwd.writeFile(.{ .sub_path = "index.html", .data = gen_index });
}
