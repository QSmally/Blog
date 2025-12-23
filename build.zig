
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zmpl = b.dependency("zmpl", .{
        .target = target,
        .optimize = optimize });

    const exec = b.addExecutable(.{
        .name = "site",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize });
    exec.root_module.addImport("zmpl", zmpl.module("zmpl"));
    b.installArtifact(exec);

    const gen_templates = b.addRunArtifact(exec);
    const gen_step = b.step("gen", "generate templates in-place");
    gen_step.dependOn(&gen_templates.step);
}
