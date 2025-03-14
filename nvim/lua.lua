local function my_on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    -- api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set('n', '?', api.tree.toggle_help, opts("Help"))
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts("Open"))
end

-- pass to setup along with your other options
require("nvim-tree").setup {
    on_attach = my_on_attach,
    disable_netrw = False,
    hijack_netrw = True,
    git = {
        enable = false
    }
}

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local invalid_win = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then
        table.insert(invalid_win, w)
      end
    end
    if #invalid_win == #wins - 1 then
      -- Should quit, so we close all invalid windows.
      for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
    end
  end
})

vim.api.nvim_create_user_command('CompileLatex', function()
    -- Check if Makefile exists in the current directory
    local makefile = vim.fn.getcwd() .. '/Makefile'
    if vim.fn.filereadable(makefile) == 1 then
        -- Run make if Makefile exists
        vim.fn.jobstart({'make'}, {
            on_stdout = function(_, data)
                if data then
                    print(table.concat(data, '\n'))
                end
            end,
            on_stderr = function(_, data)
                if data then
                    print(table.concat(data, '\n'))
                end
            end,
            on_exit = function(_, code)
                if code == 0 then
                    print("Compile successful!")
                else
                    print("Compile failed!")
                end
            end,
        })
    else
        -- Run pdflatex on the current file if no Makefile exists
        local current_file = vim.fn.expand('%')
        vim.fn.jobstart({'pdflatex', current_file}, {
            on_stdout = function(_, data)
                if data then
                    print(table.concat(data, '\n'))
                end
            end,
            on_stderr = function(_, data)
                if data then
                    print(table.concat(data, '\n'))
                end
            end,
            on_exit = function(_, code)
                if code == 0 then
                    print("Compile successful!")
                else
                    print("Compile failed!")
                end
            end,
        })
    end
end, {})


-- Check if SSH_TTY is set
if vim.fn.getenv('SSH_TTY') ~= vim.NIL then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end
