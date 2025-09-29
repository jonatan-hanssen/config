local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function filetype_picker(opts)
  opts = opts or {}

  -- Dynamically fetch available filetypes
  local filetypes = vim.fn.getcompletion('', 'filetype')

  pickers.new(opts, {
    prompt_title = "Set Filetype",
    finder = finders.new_table {
      results = filetypes,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local ft = selection[1]
        vim.cmd("set filetype=" .. ft)
        print("Filetype set to: " .. ft)
      end)
      return true
    end,
  }):find()
end

return require("telescope").register_extension {
  exports = {
    filetype_picker = filetype_picker,
  },
}
