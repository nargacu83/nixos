local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
require("status.archupdates")

local icon_path = os.getenv("HOME") .. "/.config/awesome/theme/icons/package.svg"
local icon_recolored = gears.color.recolor_image(icon_path, "#282a36")
local icon = {
    widget = wibox.container.place,
    {
        widget = wibox.widget.imagebox,
        image = icon_path,
        forced_width = 15,
        resize = true,
    },
}
local bg_shape = function (cr, w, h) gears.shape.rounded_rect(cr, w, h, 3) end
local arch_updates = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "<span>...</span>",
}

local widget = {
    widget = wibox.container.margin,
    top = 6,
    bottom = 6,

    {
        widget = wibox.container.background,
        bg = "#6272a4",
        shape = bg_shape,
        {
            widget = wibox.container.margin,
            left = 5,
            right = 5,

            {
                widget = wibox.container.place,
                layout = wibox.layout.fixed.horizontal,
                spacing = 5,

                icon,
                arch_updates
            }
        },
    },
}

awesome.connect_signal("status::archupdates", function(count)
    arch_updates.font = beautiful.font
    arch_updates.markup = "<span>" .. count .. "</span>"
end)

return widget
