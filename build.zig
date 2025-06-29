const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const qjsMod = b.createModule(.{
        .target = target,
        .optimize = optimize,
    });

    const flags = [_][]const u8{
        "-std=gnu11",
        "-DZIG_BUILD",
        "-D_GNU_SOURCE",
    };

    qjsMod.addCSourceFiles(.{
        .files = &.{
            "cutils.c",
            "libregexp.c",
            "libunicode.c",
            "quickjs.c",
            "xsum.c",
            "quickjs-libc.c",
        },
        .flags = &flags,
    });

    const dynlib = b.addLibrary(.{
        .linkage = .dynamic,
        .name = "quickjs",
        .root_module = qjsMod,
    });
    dynlib.linkLibC();
    b.installArtifact(dynlib);
}
