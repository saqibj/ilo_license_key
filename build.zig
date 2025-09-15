const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    
    // Build the library
    const lib = b.addStaticLibrary("ilo_license_key", "src/main.zig");
    lib.setBuildMode(mode);
    lib.install();

    // Build the example program
    const exe = b.addExecutable("example", "src/example.zig");
    exe.setBuildMode(mode);
    exe.install();

    // Build the CLI program
    const cli = b.addExecutable("cli", "src/cli.zig");
    cli.setBuildMode(mode);
    cli.install();

    // Run the example
    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the example program");
    run_step.dependOn(&run_cmd.step);

    // Run the CLI
    const run_cli_cmd = cli.run();
    run_cli_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cli_cmd.addArgs(args);
    }

    const run_cli_step = b.step("run-cli", "Run the CLI program");
    run_cli_step.dependOn(&run_cli_cmd.step);

    // Tests
    var main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
