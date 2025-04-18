return {
    { 'numToStr/Comment.nvim' }, -- gc to comment
    { 'itchyny/vim-gitbranch' }, -- git branch in statusline
    { 'kshenoy/vim-signature' }, -- see marks
    { 'folke/tokyonight.nvim' }, -- other colorscheme
    { 'chaoren/vim-wordmotion' }, -- CamelCase and snake_case word boundaries
    { 'tpope/vim-surround' }, -- surround motions
    { 'tpope/vim-repeat' }, -- repeat vim-surround
    { 'ap/vim-css-color' }, -- see colors in the editor
    { 'stevearc/vim-arduino', ft = { 'arduino' } }, -- arduino builds
    {
        'neoclide/coc.nvim', -- lsp
        branch = release,
        config = function()
            -- Tab completion mapping
            vim.api.nvim_set_keymap('i', '<TAB>', [[coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "\<Tab>" : coc#refresh()]], {expr = true, silent = true})
            vim.api.nvim_set_keymap('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], {expr = true, silent = true})

            -- Function to check backspace
            function CheckBackspace()
              local col = vim.fn.col('.') - 1
              return col == 0 or string.match(vim.fn.getline('.'):sub(col, col), '%s') ~= nil
            end


            -- Function to show documentation
            function ShowDocumentation()
              if vim.fn.CocAction('hasProvider', 'hover') then
                vim.fn.CocActionAsync('doHover')
              else
                vim.api.nvim_feedkeys('K', 'in', false)
              end
            end

            -- GoTo code navigation
            vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', {silent = true})

            -- Toggle documentation preview
            vim.api.nvim_set_keymap('n', '?', ':lua ShowDocumentation()<CR>', {silent = true})
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
            end

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
        'lervag/vimtex', -- latex, only using this for ToC
        ft = "tex",
        config = function()
            vim.g.vimtex_toc_config = {
                layers = { 'content' },
                mode = 1,
                show_help = 0,
                tocdepth = 2,
                indent_levels = 1,
                split_pos = 'full',
            }

            vim.g.vimtex_compiler_enabled = 0
            vim.g.vimtex_complete_enabled = 0
            vim.g.vimtex_doc_enabled = 0
            vim.g.vimtex_syntax_enabled = 0
            vim.g.vimtex_imaps_enabled = 0
            vim.g.vimtex_mappings_enabled = 0
            vim.g.vimtex_matchparen_enabled = 0
            vim.g.vimtex_fold_enabled = 0
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter', -- better highlights
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs', -- Sets main module to use for opts
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
        opts = {
            ensure_installed = { 'bash', 'c', 'diff', 'html', 'latex', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'python' },
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
        },
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config Release'
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup{
                defaults = {
                    mappings = {
                        i = {
                            ["<C-e>"] = "close",
                            ["<C-i>"] = "close",
                        },
                        n = {
                            ["<C-e>"] = "close",
                            ["<C-i>"] = "close",
                        },
                    }
                }
            }

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<C-i>', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', '<C-e>', builtin.live_grep, { desc = 'Telescope live grep' })
        end
    }

}
