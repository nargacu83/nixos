local awful = require("awful")

local interval = 2

awful.widget.watch(
  "gpu-usage",
  interval,
  function(_, stdout)
    awesome.emit_signal("status::gpu", stdout)
  end)
