
const std = @import("std");
const zmpl = @import("zmpl");

const Manifest = struct {
    name: []const u8,
    title: []const u8,
    description: []const u8,

    visibility: enum { featured, visible, invisible } = .invisible,
    created: []const u8 = "never",
    last_change: ?[]const u8 = null,
    thumbnail: ?[]const u8 = null,
    changelog: []const Change = &.{},

    pub const Change = struct {
        date: []const u8,
        description: []const u8
    };
};

const Post = struct {
    directory_path: []const u8,
    manifest: Manifest
};

const PageContext = struct {
    posts: []const Post,
    manifest: Manifest
};

const gpg_path = "publish/public-key.gpg";

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const arena = init.arena.allocator();
    const cwd = std.Io.Dir.cwd();

    const posts = try fetchSortedPostsOwned(io, arena, cwd, "posts");

    try generateIndexFile(io, arena, cwd, posts);

    for (posts) |post| {
        const post_template = getTemplate("post");
        const viewport_template = getTemplate("viewport");

        const input_path = try std.fs.path.join(arena, &.{ post.directory_path, "index.zmpl.html" });
        const output_path = try std.fs.path.join(arena, &.{ post.directory_path, "index.html" });
        const signature_path = try std.fs.path.join(arena, &.{ post.directory_path, "index.zmpl.html.asc" });

        try verifyGpgSignature(io, arena, cwd, input_path, signature_path);

        const content = try readFileOwned(io, arena, cwd, input_path);
        const signature = try readFileOwned(io, arena, cwd, signature_path);

        var data = zmpl.Data.init(io, arena);
        var body = try data.object();
        try body.put("content", data.string(content));
        try body.put("signature", data.string(signature));

        const generated_post = try post_template.render(
            io,
            &data,
            PageContext,
            .{ .posts = posts, .manifest = post.manifest },
            &.{},
            .{ .layout = viewport_template });
        try cwd.writeFile(io, .{ .sub_path = output_path, .data = generated_post });
    }

    std.log.info("all ready!", .{});
}

fn getTemplate(identifier: []const u8) zmpl.Template {
    return zmpl.find(identifier) orelse @panic("Template not found");
}

fn fetchSortedPostsOwned(
    io: std.Io,
    arena: std.mem.Allocator,
    pwd: std.Io.Dir,
    path: []const u8
) ![]const Post {
    const dir = try pwd.openDir(io, path, .{ .iterate = true });
    defer dir.close(io);

    var iterator = dir.iterate();

    var post_list: std.ArrayList(Post) = .empty;

    while (try iterator.next(io)) |blog_post_entry| {
        if (blog_post_entry.kind != .directory)
            continue;

        const directory_path = try std.fs.path.join(arena, &.{ path, blog_post_entry.name });

        std.log.info("init blog post: {s}", .{ directory_path });

        const manifest_path = try std.fs.path.join(arena, &.{ directory_path, "index.zon" });
        const manifest_content = try readFileOwned(io, arena, pwd, manifest_path);
        const manifest = try parseZon(Manifest, arena, manifest_content);

        try post_list.append(arena, .{
            .directory_path = directory_path,
            .manifest = manifest });
    }

    const posts = try post_list.toOwnedSlice(arena);
    std.mem.sortUnstable(Post, posts, {}, fnSortPost);

    std.log.info("{} blog posts ready", .{ posts.len });

    return posts;
}

fn fnSortPost(_: void, lhs: Post, rhs: Post) bool {
    return !dateStringSort(lhs.manifest.created, rhs.manifest.created);
}

fn dateStringSort(lhs: []const u8, rhs: []const u8) bool {
    var lhs_components = std.mem.splitScalar(u8, lhs, '-');
    var rhs_components = std.mem.splitScalar(u8, rhs, '-');

    while (true) {
        const lhs_component = lhs_components.next() orelse return false;
        const rhs_component = rhs_components.next() orelse return false;

        const lhs_numeric = std.fmt.parseInt(u32, lhs_component, 0) catch 0;
        const rhs_numeric = std.fmt.parseInt(u32, rhs_component, 0) catch 0;

        if (lhs_numeric < rhs_numeric)
            return true;
        if (lhs_numeric > rhs_numeric)
            return false;
    }

    return false;
}

test dateStringSort {
    try std.testing.expectEqual(false, dateStringSort("0000", "0000"));
    try std.testing.expectEqual(true, dateStringSort("0000", "0001"));
    try std.testing.expectEqual(false, dateStringSort("0000-00-00", "0000-00-00"));
    try std.testing.expectEqual(true, dateStringSort("2025-01-01", "2026-01-01"));
    try std.testing.expectEqual(false, dateStringSort("2027-01-01", "2026-01-01"));
    try std.testing.expectEqual(true, dateStringSort("2026-01-01", "2026-05-01"));
    try std.testing.expectEqual(true, dateStringSort("2026-05-01", "2026-05-05"));
}

fn readFileOwned(
    io: std.Io,
    arena: std.mem.Allocator,
    pwd: std.Io.Dir,
    path: []const u8
) ![:0]const u8 {
    const file = try pwd.openFile(io, path, .{});
    defer file.close(io);
    var reader = file.reader(io, &.{});

    return try reader.interface.allocRemainingAlignedSentinel(
        arena,
        .limited(32 * 1024),
        .@"1",
        0);
}

fn parseZon(comptime T: type, arena: std.mem.Allocator, zon: [:0]const u8) !T {
    return std.zon.parse.fromSliceAlloc(T, arena, zon, null, .{});
}

fn generateIndexFile(
    io: std.Io,
    arena: std.mem.Allocator,
    pwd: std.Io.Dir,
    posts: []const Post
) !void {
    var data = zmpl.Data.init(io, arena);

    const index_template = getTemplate("index");
    const viewport_template = getTemplate("viewport");

    const manifest = Manifest {
        .name = "Home Page",
        .title = "Joey Smalen",
        .description = "Smally's not-so-special blog, usually about little projects"
    };

    const generated_index = try index_template.render(
        io,
        &data,
        PageContext,
        .{ .posts = posts, .manifest = manifest },
        &.{},
        .{ .layout = viewport_template });
    try pwd.writeFile(io, .{ .sub_path = "index.html", .data = generated_index });

    std.log.info("generated index.html", .{});
}

fn verifyGpgSignature(
    io: std.Io,
    arena: std.mem.Allocator,
    pwd: std.Io.Dir,
    file_path: []const u8,
    signature_path: []const u8
) !void {
    const result = try std.process.run(arena, io, .{
        .argv = &.{
            "gpg",
            "--no-default-keyring", "--keyring", gpg_path,
            "--verify", signature_path, file_path
        },
        .cwd = .{ .dir = pwd } });
    switch (result.term) {
        .exited => |exit_code| {
            if (exit_code == 0) return;
        },
        else => {}
    }

    std.log.err("GPG of {s} is not valid", .{ file_path });
    std.log.err("{s}", .{ result.stderr });
    return error.ValidSignatureRequired;
}
