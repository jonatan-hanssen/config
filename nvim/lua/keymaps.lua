local function map(m, k, v, desc)
    local opts = { silent = true }
    if desc then
        opts.desc = desc
    end
    vim.keymap.set(m, k, v, opts)
end

-- Do an operator on every line in the file (dag, yag, =ag)
map("x", "ag", "ggoG")
map("o", "ag", ":normal Vag<cr>")

map("n", "<A-j>", ":m .+1<CR>")
map("n", "<A-k>", ":m .-2<CR>")
map("v", "<A-j>", ":m '>+1<CR>gv=gv")
map("v", "<A-k>", ":m '<-2<CR>gv=gv")

map("n", "<leader>k", ":ColorschemeToggle<cr>", "Toggle to darK colorscheme")
map("n", "<leader>p", "\"+p", "Paste from clipboard")
map("n", "<leader>y", "\"+y", "Yank to clipboard")
map("n", "<leader>Y", "\"+y$", "Yank to end of line to clipboard")
map("v", "<leader>y", "\"+y")

map("n", "E", "b")



map("n", "gp", ":put<CR>")

-- remove ighlight for last searched
map("n", "<leader><BS>", ":noh<CR>", "Remove highlights")

-- schmoovement
vim.keymap.set("n", "J", ":keepjumps normal! }<CR>", { remap = true, silent = true })
vim.keymap.set("n", "K", ":keepjumps normal! {<CR>", { remap = true, silent = true })
vim.keymap.set("o", "J", ":keepjumps normal! }<CR>", { remap = true, silent = true })
vim.keymap.set("o", "K", ":keepjumps normal! {<CR>", { remap = true, silent = true })

map("x", "J", ":<C-u>keepjumps normal! gv}<CR>")
map("x", "K", ":<C-u>keepjumps normal! gv{<CR>")


map("n", "}", "J")
map("n", "{", "?")


-- S is cc so pointless. S is for save
map("n", "S", ":w<CR>")
-- M is for middle of screen but who cares. M for Make this damn file close
map("n", "M", ":q<CR>")

-- U is undo line which is stupid
map("n", "U", "<C-r>")


-- move mellom tabs
map("n", "H", ":bprev<CR>")
map("n", "L", ":bnext<CR>")
-- replace alt som ble soekt paa sist
vim.keymap.set("n", "<leader>s", ":%s///g<Left><Left>", { desc = "Replace last searched" })
-- bedre shift yank
vim.keymap.set("n", "Y", "y$", { remap = true})

-- format python
-- make print(x) into print(f"{x=}")
map("n", "<leader>f", "0f(af'{<ESC>$i=}'<ESC>", "Make f-string")
map("n", "<leader>m", ":delmarks!<CR>", "Delete marks")
map("n", "<leader>z", ":!zathura %<.pdf & <CR><CR>", "Open associated pdf")
map("n", "<leader>d", ":bp<BAR>bd#<CR>", "Delete current buffer")
-- vim.keymap.set("n", "<leader>c", ":colorscheme ")

map("n", "<leader>h", ":SynStack<CR>", "Show regex highlight group")
