local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- Utility to get all user-defined commands
local function get_user_commands()
  local all_commands = vim.api.nvim_get_commands({})
  local user_commands = {}

  for name, cmd in pairs(all_commands) do
    if not cmd.builtin then
      table.insert(user_commands, {
        name = name,
        definition = cmd.definition or "",
        nargs = cmd.nargs or "0",
      })
    end
  end

  return user_commands
end

-- Picker logic
local function run_user_command_picker(opts)
  opts = opts or {}

  local commands = get_user_commands()

  pickers.new(opts, {
    prompt_title = "User Commands",
    finder = finders.new_table {
      results = commands,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name,
          ordinal = entry.name .. " " .. entry.definition,
        }
      end,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection and selection.value then
          -- Insert command into ":" prompt but don't run it
          vim.fn.feedkeys(":" .. selection.value.name .. " ", "n")
        end
      end)
      return true
    end,
  }):find()
end

-- Return as a Telescope extension
return require("telescope").register_extension({
  exports = {
    user_commands = run_user_command_picker,
  },
})
