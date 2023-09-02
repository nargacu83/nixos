local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local taglist = {}

local tag_width = 20
local tag_height = 6
-- local tag_shape = function (cr, w, h) gears.shape.rounded_rect(cr, w, h, 3) end
local tag_shape = function (cr, w, h) gears.shape.rounded_bar(cr, w, tag_height) end

local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

function taglist.get(s)
    local widget = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        layout = {
            spacing = 5,
            layout  = wibox.layout.fixed.horizontal
        },
        style = {shape = tag_shape},
        widget_template = {
            {
                id = 'margin_role',
                right = tag_width,
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background,
        },
        buttons = taglist_buttons
    }

    return widget
end

return taglist
