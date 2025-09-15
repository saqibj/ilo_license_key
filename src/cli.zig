const std = @import("std");
const ilo_license_key = @import("main.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        const stderr = std.io.getStdErr().writer();
        try stderr.print("Usage: {s} <license_key>\n", .{args[0]});
        try stderr.print("Example: {s} 3Q23VVTZ39HLB6LYNMNCC8YRN\n", .{args[0]});
        return;
    }

    const license_key = args[1];
    const stdout = std.io.getStdOut().writer();

    const license = ilo_license_key.IloLicenseKey.from_string(license_key) catch |err| {
        try stdout.print("Error parsing license key: {}\n", .{err});
        return;
    };

    try stdout.print("License Key: {s}\n", .{license_key});
    try stdout.print("Product ID 1: {}\n", .{license.product_id_1});
    try stdout.print("Product Version 1: {}\n", .{license.product_ver_1});
    try stdout.print("License Type: {}\n", .{license.license_type});
    try stdout.print("Transaction Date: {s}\n", .{license.format_transaction_date()});
    try stdout.print("Transaction Number: {}\n", .{license.transaction_number});
    try stdout.print("Seats/Demo: {}\n", .{license.seats_demo});
    try stdout.print("Feature Mask: {}\n", .{license.feature_mask});
}
