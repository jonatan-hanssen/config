return {
    { 'numToStr/Comment.nvim' }, -- gc to comment
    { 'itchyny/vim-gitbranch' }, -- git branch in statusline
    { 'kshenoy/vim-signature' }, -- see marks
    { 'folke/tokyonight.nvim' }, -- other colorscheme
    { 'tpope/vim-surround' }, -- surround motions
    { 'tpope/vim-repeat' }, -- repeat vim-surround
    { 'ap/vim-css-color' }, -- see colors in the editor
    { 'stevearc/vim-arduino', ft = { 'arduino' } }, -- arduino builds
    {
        'chaoren/vim-wordmotion', -- CamelCase and snake_case word boundaries
        config = function()
            vim.g.wordmotion_nomap = 1
            vim.g.wordmotion_on = 0

            vim.api.nvim_create_user_command('WordMotionToggle', function()
                if vim.g.wordmotion_on == 1 then
                    print("WordMotion off")
                    vim.g.wordmotion_on = 0
                    vim.api.nvim_del_keymap('n', 'w')
                    vim.api.nvim_del_keymap('n', 'b')
                    vim.api.nvim_del_keymap('n', 'e')
                    -- vim.api.nvim_del_keymap('n', 'iw')
                    -- vim.api.nvim_del_keymap('n', 'aw')
                else
                    print("WordMotion on")
                    vim.g.wordmotion_nomap = 0
                    vim.g.wordmotion_on = 1

                    -- Assuming you have the wordmotion functionality available
                    vim.cmd([[call wordmotion#reload()]])
                end
            end, {})

            vim.keymap.set("n", "<leader>w", ":WordMotionToggle<cr>", { nowait = true, desc = "Toggle WordMotion" })
        end,
    },
    {
        'ggandor/leap.nvim', -- go to anywhere with 's'
        config = function()
            vim.keymap.set('n',        's', '<Plug>(leap-anywhere)')
            vim.keymap.set({'x', 'o'}, 's', '<Plug>(leap)')
            -- require('leap').opts.safe_labels = {}
        end,
    },
    {
        'neoclide/coc.nvim', -- lsp, still faster than native sadly
        branch = release,
        config = function()
            -- Function to check backspace
            function _G.CheckBackspace()
                local col = vim.fn.col('.') - 1
                return col == 0 or string.match(vim.fn.getline('.'):sub(col, col), '%s') ~= nil
            end

            -- Tab completion mapping
            vim.api.nvim_set_keymap('i', '<TAB>', [[coc#pum#visible() ? coc#pum#next(1) : v:lua.CheckBackspace() ? "\<Tab>" : coc#refresh()]], {expr = true, silent = true})
            vim.api.nvim_set_keymap('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], {expr = true, silent = true})



            -- Function to show documentation
            function ShowDocumentation()
                if vim.fn.CocAction('hasProvider', 'hover') then
                    vim.fn.CocActionAsync('doHover')
                else
                    vim.api.nvim_feedkeys('K', 'in', false)
                end
            end

            -- GoTo code navigation
            vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', {silent = true, desc = "Go to definition"})

            -- Toggle documentation preview
            vim.api.nvim_set_keymap('n', '?', ':lua ShowDocumentation()<CR>', {silent = true, desc = "Open documentation"})
        end,
    },
    {
        'vimwiki/vimwiki', -- wikis
        event = { "BufEnter *.wiki", "BufRead *.wiki" },
        config = function()
            vim.g.vimwiki_ext2syntax = {}
            vim.g.vimwiki_key_mappings = { global = 0 }
        end,
    },
    {
        'ap/vim-buftabline', -- buffers in the tabline
        config = function()
            vim.g.buftabline_show = 1
        end,
    },
    {
        'nvim-tree/nvim-tree.lua', -- file view
        config = function()
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
                vim.keymap.set('n', '<ESC>', api.tree.close, opts("Close"))
            end
            vim.keymap.set("n", "<BS>", ":NvimTreeToggle<CR>", { silent = true, desc = "Open nvim-tree" })

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


            -- pass to setup along with your other options
            require("nvim-tree").setup {
                on_attach = my_on_attach,
                disable_netrw = False,
                hijack_netrw = True,
                git = {
                    enable = false
                }
            }
        end,
    },
    {
        'github/copilot.vim', -- LLM suggestions
        config = function()
            vim.keymap.set('i', '<C-N>', 'copilot#Accept("\\<CR>")', {
                expr = true,
                replace_keycodes = false
            })
            vim.g.copilot_no_tab_map = true


            vim.cmd([[Copilot disable]])
            vim.g.copilot_is_disabled = 1

            vim.api.nvim_create_user_command('CopilotToggle', function()
                if vim.g.copilot_is_disabled == 1 then
                    vim.g.copilot_is_disabled = 0
                    vim.cmd([[Copilot enable]])
                    print("Copilot on")
                else
                    vim.g.copilot_is_disabled = 1
                    vim.cmd([[Copilot disable]])
                    print("Copilot off")
                end
            end, {})

            vim.keymap.set("n", "<leader>c", ":CopilotToggle<cr>", { silent = true, noremap = true, desc = "Toggle Copilot" })
        end,
    },
    {
        'michaelb/sniprun', -- run parts of code, replaces notebooks
        build = 'sh install.sh',
        config = function()
            require('sniprun').setup({
                display = { "Api" },
                selected_interpreters = { 'Python3_fifo' },
                repl_enable = {'Python3_fifo'},
                interpreter_options = {
                    Python3_fifo = {
                        venv = {".venv", "../.venv"},
                    }
                },
            })


            function SelectCommandBlock()
                local api = vim.api
                local cmd_pattern = "^# COMMAND +%-%-+%s*$"  -- Adjust if your pattern is slightly different

                local cur_line = api.nvim_win_get_cursor(0)[1] -- Current line (1-indexed)
                local lines = api.nvim_buf_get_lines(0, 0, -1, false)
                local total_lines = #lines

                local start_line = 1
                local end_line = total_lines

                -- Search upward for previous '# COMMAND ----------'
                for i = cur_line - 1, 1, -1 do
                    if lines[i]:match(cmd_pattern) then
                        start_line = i + 1 -- Start after the command line
                        break
                    end
                end

                -- Search downward for next '# COMMAND ----------'
                for i = cur_line, total_lines do
                    if lines[i]:match(cmd_pattern) then
                        end_line = i - 1 -- End before the command line
                        break
                    end
                end

                -- If cursor is on a '# COMMAND ----------' line, start from the next line
                if lines[cur_line]:match(cmd_pattern) then
                    start_line = cur_line + 1
                    -- Optionally, adjust end_line to match new range
                    for i = cur_line + 1, total_lines do
                        if lines[i]:match(cmd_pattern) then
                            end_line = i - 1
                            break
                        end
                    end
                end

                -- Clamp values
                if start_line > total_lines then start_line = total_lines end
                if end_line > total_lines then end_line = total_lines end
                if start_line < 1 then start_line = 1 end
                if end_line < start_line then end_line = start_line end

                require'sniprun.api'.run_range(start_line, end_line)

            end

            vim.keymap.set('v', '<leader>r', '<Plug>SnipRun', {silent = true})
            vim.keymap.set('n', '<leader>r', '<Plug>SnipRun', {silent = true})
            vim.keymap.set('n', '<leader>a', function() SelectCommandBlock() end, {silent = true, desc = "Run command block"})


            local sa = require('sniprun.api')

            -- Listener that writes output to a file
            local file_writer_listener = function(d)
                local home = os.getenv("HOME") or "~"
                local filepath = home .. "/.local/share/nvim/sniprun_output"
                local file = io.open(filepath, "a")  -- append mode

                if file then
                    file:write("Status: " .. (d.status or "unknown") .. "\n")
                    file:write("Message:\n" .. (d.message or "") .. "\n")
                    file:write("----------\n")
                    file:close()
                else
                    print("Failed to open file for writing SnipRun output.")
                end
            end

            -- Register the listener
            sa.register_listener(file_writer_listener)

        end
    },
    {
        "folke/which-key.nvim", -- show keymap hints
        event = "VeryLazy",
        opts = {
            triggers = {
                { "<leader>", mode = { "n" } },
                { "g", mode = { "n" } },
            },
            layout = {
                width = { min = 20, max = 60 }, -- min and max width of the columns
            },
        },
    },
    {
        'nvim-treesitter/nvim-treesitter', -- treesitter configuration
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs', -- Sets main module to use for opts
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
        opts = {
            ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'python' },
            -- Autoinstall languages that are not installed
            auto_install = true,
            highlight = {
                enable = true,
                -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                --  If you are experiencing weird indenting issues, add the language to
                --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    node_incremental = "<cr>",
                    node_decremental = "<backspace>",
                },
            },
        },
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>tt', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', '<leader>tp', builtin.live_grep, { desc = 'Telescope grep pattern' })
            vim.keymap.set('n', '<leader>tg', builtin.git_files, { desc = 'Telescope git files' })
            vim.keymap.set('n', '<leader>ts', builtin.grep_string, { desc = 'Telescope grep string' })
            vim.keymap.set('n', '<leader>tc', function()
                builtin.find_files {
                    cwd = vim.fn.expand('~/.config')
                }
            end)
        end
    },
    {
        'stevearc/aerial.nvim',
        config = function()
            require('aerial').setup({
                backends = {
                    ['_']  = {"lsp", "treesitter"},
                    python = {"treesitter"},
                    rust   = {"lsp"},
                },
                keymaps = {
                    ["<esc>"] = "actions.close",
                    ["H"] = "actions.tree_decrease_fold_level",
                    ["L"] = "actions.tree_increase_fold_level",
                },

                post_jump_cmd = false,

                close_on_select = true,
                layout = {
                    default_direction = 'prefer_left',
                    min_width = {50, 0.3},
                },
            })
            -- You probably also want to set a keymap to toggle aerial
            vim.keymap.set("n", "<CR>", "<cmd>AerialToggle<CR>")
            opts = {} 
        end
    },
    -- {
    --     'neovim/nvim-lspconfig',
    --     config = function()
    --         vim.cmd[[set completeopt+=menuone,noselect,popup,preview]]
    --         vim.lsp.enable('pyright')
    --         vim.api.nvim_create_autocmd('LspAttach', {
    --             group = vim.api.nvim_create_augroup('my.lsp', {}),
    --             callback = function(args)
    --                 local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    --                 if client:supports_method('textDocument/implementation') then
    --                     -- Create a keymap for vim.lsp.buf.implementation ...
    --                 end
    --                 -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    --                 if client:supports_method('textDocument/completion') then
    --                     local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
    --                     client.server_capabilities.completionProvider.triggerCharacters = chars
    --                     vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
    --                 end
    --                 -- Auto-format ("lint") on save.
    --                 -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    --                 if not client:supports_method('textDocument/willSaveWaitUntil')
    --                     and client:supports_method('textDocument/formatting') then
    --                     vim.api.nvim_create_autocmd('BufWritePre', {
    --                         group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
    --                         buffer = args.buf,
    --                         callback = function()
    --                             vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
    --                         end,
    --                     })
    --                 end
    --             end,
    --         })
    --     end
    -- }, -- lsp defaults

}
