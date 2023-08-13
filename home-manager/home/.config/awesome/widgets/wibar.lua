local awful = require("awful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- local widget_padding = 8
local wibar_height = 35

-- Widget imports
local mytaglist = require("widgets.taglist")
-- local mytasklist = require("widgets.tasklist")
local mysystray = require("widgets.systray")
local mycpu = require("widgets.cpu")
local mygpu = require("widgets.gpu")
local mymemory = require("widgets.memory")
local myarchupdates = require("widgets.archupdates")
local myhourclock = require("widgets.hourclock")
local mydateclock = require("widgets.dateclock")

local wibar = {}

function wibar.get(s)
    local mywibox = awful.wibar({
        position = "top",
        screen = s,
        height = dpi(wibar_height)
    })

    local taglist = mytaglist.get(s)

    -- Add widgets to the wibox
    mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",

        {
            -- Left widgets
            widget = wibox.container.margin,
            left = 5,
            {
                widget = wibox.container.place,
                layout = wibox.layout.fixed.horizontal,
                spacing = 5,
                mydateclock,
                myhourclock,
            },
        },
        {
            -- Middle widgets
            widget = wibox.container.margin,
            -- left = 5,
            -- right = 5,
            top = 10,
            bottom = 10,
            taglist
        },
        {
            -- Right widgets
            widget = wibox.container.place,
            h_align = "right",
            {
                widget = wibox.container.margin,
                right = 5,
                {
                    widget = wibox.container.place,
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 5,
                    mycpu,
                    mygpu,
                    mymemory,
                    mysystray,
                }
            }
        }
    }

    return mywibox
end

return wibar
