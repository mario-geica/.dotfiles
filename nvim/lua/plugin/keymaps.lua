local set = vim.keymap.set


set("n", "]e", function()
  vim.diagnostic.jump({
    count = 1,
    severity = vim.diagnostic.severity.ERROR,
    float = true -- Shows diagnostic in floating window
  })
end, { desc = "Go to next error" })

set("n", "[e", function()
  vim.diagnostic.jump({
    count = -1,
    severity = vim.diagnostic.severity.ERROR,
    float = true -- Shows diagnostic in floating window
  })
end, { desc = "Go to previous error" })

set('i', '<C-s>', vim.lsp.buf.signature_help, opts)

set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
set("n", "<space><Right>", ":NvimTreeToggle<CR>")
set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle git blame" })
set("n", "<leader>gB", ":Gitsigns blame_line<CR>", { desc = "Show detailed git blame" })
set("n", "<leader>bn", ":bNext<CR>")
set("n", "<leader>bp", ":bprevious<CR>")
set("n", "<leader>bc", " :bdelete<CR>")
set("n", "<leader><Up>", ":bNext<CR>")
set("n", "<leader><Down>", ":bprevious<CR>")
set("n", "<leader>f<Left>", " :bdelete<CR>")

set("i", "<C-s>", "<esc>:w<CR>")
set("n", "<C-a>", "ggVG")
set("n", "<C-s>", ":w<CR>")

set('i', '<C-Space>', '<C-x><C-o>', { silent = true })
set('i', '<C-y>', '<C-y>', { silent = true })


set("v", "<C-Down>", ":m '>+1<CR>gv=gv")
set("v", "<C-Up>", ":m '<-2<CR>gv=gv")
set("n", "Y", "yg$")
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")
set("n", "J", "mzJ`z")
set("i", "<C-c>", "<Esc>")
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")
set("n", "<C-J>", "<C-W><C-J>")
set("n", "<C-K>", "<C-W><C-K>")
set("n", "<C-L>", "<C-W><C-L>")
set("n", "<C-H>", "<C-W><C-H>")
-- " Make windows to be basically the same size")
set("n", "<leader>=", " <C-w>=")
-- " Sizing window horizontally")
set("n", "<C-,>", "<C-W><")
set("n", "<C-.>", "<C-W>>")
set("n", "<S-LEFT>", "<C-W>5<")
set("n", "<S-RIGHT>", "<C-W>5>")
-- " Sizing window vertically")T
set("n", "<S-UP>", "<C-W>+")
set("n", "<S-DOWN>", "<C-W>-")
set('n', '<C-w>d', ':vsplit<CR>', { noremap = true, silent = true })
set('n', '<C-w>s', ':split<CR>', { noremap = true, silent = true })
set('n', '<leader>wh', ':wincmd H<CR>', { noremap = true, silent = true })
set('n', '<leader>wl', ':wincmd L<CR>', { noremap = true, silent = true })
set('n', '<leader>wj', ':wincmd J<CR>', { noremap = true, silent = true })
set('n', '<leader>wk', ':wincmd K<CR>', { noremap = true, silent = true })
