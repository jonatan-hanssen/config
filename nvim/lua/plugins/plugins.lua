return {
    { 'numToStr/Comment.nvim' }, -- gc to comment
    { 'itchyny/vim-gitbranch' }, -- git branch in statusline
    { 'kshenoy/vim-signature' }, -- see marks
    { 'tpope/vim-surround' }, -- surround motions
    { 'tpope/vim-repeat' }, -- repeat vim-surround
    -- { 'ap/vim-css-color' }, -- see colors in the editor
    { 'stevearc/vim-arduino', ft = 'arduino' }, -- arduino builds
    { 'folke/tokyonight.nvim', lazy = true }, -- other colorscheme
    { 'embark-theme/vim', lazy = true }, -- other other colorscheme
    {
        'chaoren/vim-wordmotion', -- CamelCase and snake_case word boundaries
        keys = '<leader>w',
        config = function()
            vim.g.wordmotion_nomap = 1
            vim.g.wordmotion_on = 0

            vim.api.nvim_create_user_command('WordMotionToggle', function()
                if vim.g.wordmotion_on == 1 then
                    print('WordMotion off')
                    vim.g.wordmotion_on = 0
                    vim.api.nvim_del_keymap('n', 'w')
                    vim.api.nvim_del_keymap('n', 'b')
                    vim.api.nvim_del_keymap('n', 'e')
                    -- vim.api.nvim_del_keymap('n', 'iw')
                    -- vim.api.nvim_del_keymap('n', 'aw')
                else
                    print('WordMotion on')
                    vim.g.wordmotion_nomap = 0
                    vim.g.wordmotion_on = 1

                    -- Assuming you have the wordmotion functionality available
                    vim.cmd([[call wordmotion#reload()]])
                end
            end, {})

            vim.keymap.set('n', '<leader>w', ':WordMotionToggle<cr>', { nowait = true, desc = 'Toggle WordMotion' })
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
            vim.keymap.set('i', '<TAB>', [[coc#pum#visible() ? coc#pum#next(1) : v:lua.CheckBackspace() ? '<Tab>' : coc#refresh()]], {expr = true, silent = true})
            vim.keymap.set('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : '\<C-h>']], {expr = true, silent = true})



            -- Function to show documentation
            function ShowDocumentation()
                if vim.fn.CocAction('hasProvider', 'hover') then
                    vim.fn.CocActionAsync('doHover')
                else
                    vim.api.nvim_feedkeys('K', 'in', false)
                end
            end

            -- GoTo code navigation
            vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', {silent = true, desc = 'Go to definition'})

            vim.keymap.set('n', '<leader>r', '<Plug>(coc-rename)', {silent = true, desc = 'Rename workspace wide'})

            -- Toggle documentation preview
            vim.keymap.set('n', '?', ':lua ShowDocumentation()<CR>', {silent = true, desc = 'Open documentation'})
        end,
    },
    {
        'vimwiki/vimwiki', -- wikis
        event = { 'BufEnter *.wiki', 'BufRead *.wiki' },
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
        keys = '<BS>',
        config = function()
            local function my_on_attach(bufnr)
                local api = require 'nvim-tree.api'

                local function opts(desc)
                    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                -- default mappings
                -- api.config.mappings.default_on_attach(bufnr)

                -- custom mappings
                vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))

                vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
                vim.keymap.set('n', '<ESC>', api.tree.close, opts('Close'))
            end
            vim.keymap.set('n', '<BS>', ':NvimTreeToggle<CR>', { silent = true, desc = 'Open nvim-tree' })

            vim.api.nvim_create_autocmd('QuitPre', {
                callback = function()
                    local invalid_win = {}
                    local wins = vim.api.nvim_list_wins()
                    for _, w in ipairs(wins) do
                        local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                        if bufname:match('NvimTree_') ~= nil then
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
            require('nvim-tree').setup {
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
        keys = '<leader>c',

        init = function()
            vim.g.copilot_no_tab_map = true
        end,

        config = function()


            vim.cmd([[Copilot disable]])
            vim.g.copilot_is_disabled = 1

            vim.api.nvim_create_user_command('CopilotToggle', function()
                if vim.g.copilot_is_disabled == 1 then
                    vim.g.copilot_is_disabled = 0
                    vim.cmd([[Copilot enable]])
                    vim.keymap.set('i', '<C-N>', 'copilot#Accept("\\<CR>")', {
                        expr = true,
                        replace_keycodes = false
                    })
                    vim.cmd([[Copilot status]])
                else
                    vim.g.copilot_is_disabled = 1
                    vim.cmd([[Copilot disable]])
                    print('Copilot: Disabled')
                end
            end, {})

            vim.keymap.set('n', '<leader>c', ':CopilotToggle<cr>', { silent = true, noremap = true, desc = 'Toggle Copilot' })
        end,
    },
    {
        'michaelb/sniprun', -- run parts of code, replaces notebooks
        build = 'sh install.sh',
        keys = {
            {'<leader><cr>'},
            {'<leader><cr>', mode = 'v'},
            {'<CR>'},
        },
        config = function()
            require('sniprun').setup({
                display = { 'Api' },
                selected_interpreters = { 'Python3_fifo' },
                repl_enable = {'Python3_fifo'},
                interpreter_options = {
                    Python3_fifo = {
                        venv = {'.venv', '../.venv'},
                    }
                },
            })


            function SelectCommandBlock()
                local api = vim.api
                local cmd_pattern = '^# COMMAND +%-%-+%s*$'  -- Adjust if your pattern is slightly different

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

            vim.keymap.set('v', '<leader><cr>', '<Plug>SnipRun', {silent = true})
            vim.keymap.set('n', '<leader><cr>', '<Plug>SnipRun', {silent = true})
            vim.keymap.set('n', '<CR>', function() SelectCommandBlock() end, {silent = true, desc = 'Run command block'})


            local sa = require('sniprun.api')

            -- Listener that writes output to a file
            local file_writer_listener = function(d)
                local home = os.getenv('HOME') or '~'
                local filepath = home .. '/.local/share/nvim/sniprun_output'
                local file = io.open(filepath, 'a')  -- append mode

                if file then
                    file:write('Status: ' .. (d.status or 'unknown') .. '\n')
                    file:write('Message:\n' .. (d.message or '') .. '\n')
                    file:write('----------\n')
                    file:close()
                else
                    print('Failed to open file for writing SnipRun output.')
                end
            end

            -- Register the listener
            sa.register_listener(file_writer_listener)

        end
    },
    {
        'folke/which-key.nvim', -- show keymap hints
        opts = {
            triggers = {
                { '<leader>', mode = { 'n' } },
                { 'g', mode = { 'n' } },
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
            injections = { enable = true },
            incremental_selection = {

                enable = true,
                keymaps = {
                    node_incremental = '<cr>',
                    node_decremental = '<backspace>',
                },
            },
        },
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        keys = {'<leader>t', '<C-n>', '<leader><leader>'},
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make'
            },
        },
        config = function()
            require('telescope').load_extension('fzf')
            require('telescope').load_extension('filetype_picker')

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = 'Find file' })
            vim.keymap.set('n', '<leader>tt', function() 
                builtin.buffers { sort_lastused = true }
            end, { desc = 'Find buffers' })
            vim.keymap.set('n', '<C-n>', builtin.find_files, { desc = 'Find file' })
            vim.keymap.set('n', '<leader>tp', builtin.live_grep, { desc = 'Grep pattern' })
            vim.keymap.set('n', '<leader>tn', builtin.git_files, { desc = 'FiNd file iN repo' })
            vim.keymap.set('n', '<leader>ts', builtin.grep_string, { desc = 'Grep string under cursor' })
            vim.keymap.set('n', '<leader>tf', '<cmd>Telescope filetype_picker<CR>', { desc = 'Pick and set filetype' })
            vim.keymap.set('n', '<leader>tu', builtin.commands, { desc = 'Select user command' })
            vim.keymap.set('n', '<leader>tc', function()
                builtin.find_files {
                    cwd = vim.fn.expand('~/.config')
                }
            end, { desc = 'Find file in .config' })
        end
    },
    {
        'stevearc/aerial.nvim',
        keys = '<leader>a',
        config = function()
            require('aerial').setup({
                backends = {
                    ['_']  = {'lsp', 'treesitter'},
                    python = {'treesitter'},
                    rust   = {'lsp'},
                },
                keymaps = {
                    ['<esc>'] = 'actions.close',
                    ['H'] = 'actions.tree_decrease_fold_level',
                    ['L'] = 'actions.tree_increase_fold_level',
                },

                post_jump_cmd = false,

                close_on_select = true,
                layout = {
                    default_direction = 'prefer_left',
                    min_width = {50, 0.3},
                },

                disable_max_lines = 10000000000,
                disable_max_size = 10000000000,
            })
            -- You probably also want to set a keymap to toggle aerial
            vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle<CR>')
            opts = {}
        end
    },
    {
        "hat0uma/csvview.nvim",
        ---@module "csvview"

        ---@type CsvView.Options
        opts = {
            parser = { comments = { "#", "//" } },
            keymaps = {
                -- Text objects for selecting fields
                textobject_field_inner = { "if", mode = { "o", "x" } },
                textobject_field_outer = { "af", mode = { "o", "x" } },
                -- Excel-like navigation:
                -- Use <Tab> and <S-Tab> to move horizontally between fields.
                -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
                -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
                jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
                jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
                jump_next_row = { "<Enter>", mode = { "n", "v" } },
                jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
            },
        },
        cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function() 
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["<leader>j"] = "@function.outer",
                            ["]]"] = "@class.outer",
                            ["]b"] = "@block.outer",
                            ["]a"] = "@parameter.inner",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["gJ"] = "@function.outer",
                            ["]["] = "@class.outer",
                            ["]B"] = "@block.outer",
                            ["]A"] = "@parameter.inner",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["<leader>k"] = "@function.outer",
                            ["[["] = "@class.outer",
                            ["[b"] = "@block.outer",
                            ["[a"] = "@parameter.inner",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["gK"] = "@function.outer",
                            ["[]"] = "@class.outer",
                            ["[B"] = "@block.outer",
                            ["[A"] = "@parameter.inner",
                        },
                    },
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["ab"] = "@block.outer",
                            ["ib"] = "@block.inner",
                            ["al"] = "@loop.outer",
                            ["il"] = "@loop.inner",
                            ["a/"] = "@comment.outer",
                            ["i/"] = "@comment.outer", -- no inner for comment
                            ["aa"] = "@parameter.outer", -- parameter -> argument
                            ["ia"] = "@parameter.inner",
                        },
                    },
                },
            })
        end,
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
    --                 -- Auto-format ('lint') on save.
    --                 -- Usually not needed if server supports 'textDocument/willSaveWaitUntil'.
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
