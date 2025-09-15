const std = @import("std");
const ilo_license_key = @import("main.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdout = std.io.getStdOut().writer();

    try stdout.print("HP iLO License Key Validator Demo\n");
    try stdout.print("================================\n\n");

    // Example 1: Parse a valid license key
    try stdout.print("1. Parsing a valid license key:\n");
    const valid_key = "3Q23VVTZ39HLB6LYNMNCC8YRN";
    try stdout.print("   Key: {s}\n", .{valid_key});
    
    const license = ilo_license_key.IloLicenseKey.from_string(valid_key) catch |err| {
        try stdout.print("   Error: {}\n", .{err});
        return;
    };
    
    try stdout.print("   Product ID 1: {}\n", .{license.product_id_1});
    try stdout.print("   Product Version 1: {}\n", .{license.product_ver_1});
    try stdout.print("   License Type: {}\n", .{license.license_type});
    try stdout.print("   Transaction Date: {s}\n", .{license.format_transaction_date()});
    try stdout.print("   Transaction Number: {}\n", .{license.transaction_number});
    try stdout.print("   Seats/Demo: {}\n", .{license.seats_demo});
    try stdout.print("   Feature Mask: {}\n", .{license.feature_mask});
    try stdout.print("\n");

    // Example 2: Create a license key from data
    try stdout.print("2. Creating a license key from data:\n");
    const new_license = ilo_license_key.IloLicenseKey{
        .product_id_1 = 6, // Reserved for Test
        .product_ver_1 = 1,
        .product_id_2 = 0,
        .product_ver_2 = 0,
        .product_id_3 = 0,
        .product_ver_3 = 0,
        .license_type = 1, // FQL
        .transaction_date = 7470, // 2020-05-14
        .transaction_number = 0x3ffff,
        .seats_demo = 1337,
        .feature_mask = 0,
        .reserved = 0,
    };
    
    const generated_key = new_license.to_string();
    try stdout.print("   Generated key: {s}\n", .{generated_key});
    try stdout.print("   Transaction date: {s}\n", .{new_license.format_transaction_date()});
    try stdout.print("\n");

    // Example 3: Error handling
    try stdout.print("3. Error handling examples:\n");
    
    // Wrong length
    const short_key = "3Q23VVTZ39HLB";
    try stdout.print("   Testing short key: {s}\n", .{short_key});
    ilo_license_key.IloLicenseKey.from_string(short_key) catch |err| {
        try stdout.print("   Error: {}\n", .{err});
    };
    
    // Wrong first character
    const wrong_first = "4Q23VVTZ39HLB6LYNMNCC8YRN";
    try stdout.print("   Testing wrong first char: {s}\n", .{wrong_first});
    ilo_license_key.IloLicenseKey.from_string(wrong_first) catch |err| {
        try stdout.print("   Error: {}\n", .{err});
    };
    
    // Invalid character
    const invalid_char = "3AAAAAAAA9HLB6LYNMNCC8YRN";
    try stdout.print("   Testing invalid character: {s}\n", .{invalid_char});
    ilo_license_key.IloLicenseKey.from_string(invalid_char) catch |err| {
        try stdout.print("   Error: {}\n", .{err});
    };
    
    // Checksum error
    const checksum_error = "3Q23VVTZ39HLB6LYNMNCC8YRX";
    try stdout.print("   Testing checksum error: {s}\n", .{checksum_error});
    ilo_license_key.IloLicenseKey.from_string(checksum_error) catch |err| {
        try stdout.print("   Error: {}\n", .{err});
    };

    try stdout.print("\nDemo completed!\n");
}