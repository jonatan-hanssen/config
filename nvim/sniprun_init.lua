require('options')
require('keymaps')
require('functions')

-- Disable line wrapping
vim.o.wrap = false

-- Track file change time
local last_changedtick = vim.b.changedtick or 0

-- Periodic checktime + scroll-to-bottom on update
vim.fn.timer_start(1000, function()
  -- Save current changedtick
  local prev_tick = vim.b.changedtick or 0

  -- Trigger check for external file changes
  vim.cmd('checktime')

  -- Delay slightly to ensure Neovim processes file reload
  vim.defer_fn(function()
    -- If changedtick has increased, the file was reloaded
    if (vim.b.changedtick or 0) > prev_tick then
      vim.cmd('normal! G') -- Go to bottom
    end
  end, 100)
end, { ["repeat"] = -1 })
