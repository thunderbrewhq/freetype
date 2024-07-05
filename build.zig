const std = @import("std");

pub fn build(b: *std.Build) void {
  const target = b.standardTargetOptions(.{});
  const optimize = b.standardOptimizeOption(.{});

  // const t = target.result;

  const freetype = b.addStaticLibrary(.{
    .name = "freetype",
    .target = target,
    .optimize = optimize
  });

  // Link C standard library
  freetype.linkLibC();

  // Include "include/"
  freetype.addIncludePath(b.path("include"));

  // Build as a library
  freetype.defineCMacro("FT2_BUILD_LIBRARY", "1");

  const freetype_compiler_flags = [_][]const u8 {
    "-std=c11",
    // Disable UBsan 
    "-fno-sanitize=undefined"
  };

  const freetype_base_sources = [_][]const u8 {
    "src/autohint/ahoptim.c",
    "src/autohint/autohint.c",
    "src/base/ftbase.c",
    "src/base/ftbbox.c",
    "src/base/ftextend.c",
    "src/base/ftglyph.c",
    "src/base/ftinit.c",
    "src/base/ftmm.c",
    "src/base/ftsynth.c",
    "src/base/ftsystem.c",
    "src/cid/cidgload.c",
    "src/cid/cidload.c",
    "src/cid/cidobjs.c",
    "src/cid/cidparse.c",
    "src/cid/cidriver.c",
    "src/cff/cff.c",
    "src/pcf/pcf.c",
    "src/psaux/psaux.c",
    "src/pshinter/pshinter.c",
    "src/psnames/psnames.c",
    "src/raster/raster.c",
    "src/sfnt/sfnt.c",
    "src/smooth/smooth.c",
    "src/truetype/truetype.c",
    "src/type1/type1.c",
    "src/winfonts/winfnt.c"
  };

  // const freetype_windows_base_sources = [_][]const u8 {
  //   "builds/windows/ftsystem.c",
  //   "builds/windows/ftdebug.c"
  // };

  // const freetype_macos_base_sources = [_][]const u8 {
  //   "src/base/ftmac.c",
  //   "src/base/ftdebug.c",
  //   "builds/unix/ftsystem.c"
  // };

  // const freetype_linux_base_sources = [_][]const u8 {
  //   "src/base/ftmac.c",
  //   "src/base/ftdebug.c",
  //   "builds/unix/ftsystem.c"
  // };

  freetype.addCSourceFiles(.{
    .files = &freetype_base_sources,
    .flags = &freetype_compiler_flags
  });

  // switch (t.os.tag) {
  //   .windows => {
  //     freetype.addCSourceFiles(.{
  //       .files = &freetype_windows_base_sources,
  //       .flags = &freetype_compiler_flags
  //     });
  //   },

  //   .macos => {
  //     freetype.defineCMacro("HAVE_UNISTD_H", "1");
  //     freetype.defineCMacro("HAVE_FCNTL_H", "1");
  //     freetype.addCSourceFiles(.{
  //       .files = &freetype_macos_base_sources,
  //       .flags = &freetype_compiler_flags
  //     });
  //   },

  //   else => {
  //     freetype.defineCMacro("HAVE_UNISTD_H", "1");
  //     freetype.defineCMacro("HAVE_FCNTL_H", "1");
  //     freetype.addCSourceFiles(.{
  //       .files = &freetype_linux_base_sources,
  //       .flags = &freetype_compiler_flags
  //     });
  //   }
  // }

  freetype.installHeadersDirectory(b.path("include"), ".", .{ .include_extensions = &.{ ".h" } });
  
  b.installArtifact(freetype);
}