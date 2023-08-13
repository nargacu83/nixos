local awful = require("awful")

local interval = 2

awful.widget.watch(
  os.getenv("HOME") .. "/.local/bin/gpu-usage",
  interval,
  function(_, stdout)
    awesome.emit_signal("status::gpu", stdout)
  end)
