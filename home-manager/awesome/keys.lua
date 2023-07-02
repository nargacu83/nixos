local gears = require("gears")
local awful = require("awful")

local M = {}

-- Default modkey.
modkey = "Mod4"

-- {{{ Key bindings
M.globalkeys = gears.table.join(
	awful.key({ modkey,           }, "q", function () if client.focus == nil then return end client.focus:kill() end,
              {description = "close", group = "client"}),
	awful.key({ modkey }, "r",
		function ()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:emit_signal(
					"request::activate", "key.unminimize", {raise = true}
				)
			end
		end,
	{ description = "restore minimized", group = "client" }),

    -- Awesome
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    -- awful.key({ modkey, "Control" }, "q", awesome.quit,
    --           {description = "quit awesome", group = "awesome"}),

    -- Focus window
    awful.key({ modkey,           }, "j", function () awful.client.focus.byidx(1) end,
              {description = "focus next by index", group = "client"}),
    awful.key({ modkey,           }, "k", function () awful.client.focus.byidx(-1) end,
              {description = "focus previous by index", group = "client"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact(0.05) end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05) end,
              {description = "decrease master width factor", group = "layout"}),

    -- Swap window
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(1) end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx(-1) end,
              {description = "swap with previous client by index", group = "client"}),

    -- Next layout
    awful.key({ modkey,           }, "Tab", function () awful.layout.inc(1) end,
              {description = "select next", group = "layout"}),

    -- Toggle floating on window
    awful.key({ modkey,           }, "f", awful.client.floating.toggle,
              {description = "toggle floating", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    M.globalkeys = gears.table.join(M.globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"})
        -- Toggle tag on focused client.
        -- awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
        --           function ()
        --               if client.focus then
        --                   local tag = client.focus.screen.tags[i]
        --                   if tag then
        --                       client.focus:toggle_tag(tag)
        --                   end
        --               end
        --           end,
        --           {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

M.clientbuttons = gears.table.join(
    -- Mouse left button
    awful.button({}, 1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    -- Mouse middle button
    awful.button({}, 2,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    -- Mouse right button
    awful.button({}, 3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    awful.button({modkey}, 1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            -- Enable floating if it's not already
            if not c.floating then
                c.floating_geometry = nil
                c.floating = true
            end
            c.fullscreen = false
            c.maximized = false
            c.maximized_horizontal = false
            c.maximized_vertical = false
            awful.mouse.client.move(c)
        end
    ),
    awful.button({modkey}, 3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            -- Enable floating if it's not already
            if not c.floating then
                c.floating_geometry = nil
                c.floating = true
            end
            c.fullscreen = false
            c.maximized = false
            c.maximized_horizontal = false
            c.maximized_vertical = false
            awful.mouse.client.resize(c)
        end
    )
)

return M
