local awful = require("awful")

local interval = 2

awful.widget.watch('cpu-usage', interval,
  function(_, stdout)
    awesome.emit_signal("status::cpu", stdout)
  end)
