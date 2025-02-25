const std = @import("std");
const jetzig = @import("jetzig");

pub fn index(request: *jetzig.Request) !jetzig.View {
    const params = try request.params();
    if (params.get("redirect")) |location| {
        switch (location.*) {
            // Value is `.null` when param is empty, e.g.:
            // `http://localhost:8080/redirect?redirect`
            .null => return request.redirect("http://www.example.com/", .moved_permanently),
            // Value is `.string` when param is present, e.g.:
            // `http://localhost:8080/redirect?redirect=https://jetzig.dev/`
            .string => |string| return request.redirect(string.value, .moved_permanently),
            else => unreachable,
        }
    }

    try request.response.headers.append("foobar", "hello");
    return request.render(.ok);
}
