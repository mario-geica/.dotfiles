local Remap = require("mmm.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local nmap = Remap.nmap


nnoremap("<leader>fc", ":Neoformat<CR>")

nnoremap("<leader><Right>", ":NvimTreeToggle<CR>")
nnoremap("<leader>tt", ":NvimTreeToggle<CR>")
nnoremap("<leader>r", ":NvimTreeRefresh<CR>")
inoremap("<C-s>", "<esc>:w<CR>")
nnoremap("<C-a>", "ggVG")
nnoremap("<C-s>", ":w<CR>")

nnoremap("<leader>bn", ":bNext<CR>")
nnoremap("<leader>bp", ":bprevious<CR>")
nnoremap("<leader>bc", " :bdelete<CR>")
nnoremap("<leader><Up>", ":bNext<CR>")
nnoremap("<leader><Down>", ":bprevious<CR>")
nnoremap("<leader>f<Left>", " :bdelete<CR>")

xnoremap("<leader>p", "\"_dP")
nnoremap("<leader>y", "\"+y")
vnoremap("<leader>y", "\"+y")
nmap("<leader>Y", "\"+Y")

nnoremap("<leader>d", "\"_d")
vnoremap("<leader>d", "\"_d")

vnoremap("<C-Down>", ":m '>+1<CR>gv=gv")
vnoremap("<C-Up>", ":m '<-2<CR>gv=gv")
nnoremap("Y", "yg$")
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("J", "mzJ`z")

inoremap("<C-c>", "<Esc>")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

nnoremap("<leader>gca", ":Lspsaga code_action<CR>")
nnoremap("<leader>gh", ":Lspsaga hover_doc<CR>")
nnoremap("<leader>gcd", ":Lspsaga peek_definition<CR>")
-- nnoremap ("<leader>gsd"  , ":Lspsaga show_line_diagnostics<CR>")
-- nnoremap ("<leader>gee"  , ":Lspsaga diagnostic_jump_next<CR>")
nnoremap("<leader>grn", ":Lspsaga rename<CR>")

nnoremap("<leader>gd", ":lua vim.lsp.buf.definition()<CR>")
nnoremap("<leader>gi", ":lua vim.lsp.buf.implementation()<CR>")
-- nnoremap("<leader>gh",":lua vim.lsp.buf.signature_help()<CR>")
-- nnoremap("<leader>gr",":lua vim.lsp.buf.references()<CR>")
-- nnoremap("<leader>grn",":lua vim.lsp.buf.rename()<CR>")
nnoremap("<leader>hh", ":lua vim.lsp.buf.hover()<CR>")
-- nnoremap("<leader>ca",":lua vim.lsp.buf.code_action()<CR>")
-- nnoremap("<leader>gsd",":lua vim.diagnostic.sh ow() <CR>")
nnoremap("<leader>gfc", ":lua vim.lsp.buf.format()<CR>")

nnoremap("<leader>gee", ":lua vim.diagnostic.goto_next()<CR>")
nnoremap("<leader>gm", ":lua vim.diagnostic.goto_prev()<CR>")
--nnoremap("<leader>sd",":lua vim.diagnostic.open_float()<CR>")
--
-- nnoremap("<leader>gse",":Lspsaga show_line_diagnostics<CR>")
-- nnoremap("<leader>",":Lspsaga yank_line_diagnostics<CR>")
-- nnoremap("<leader>gca",":Lspsaga code_action<CR>")
-- nnoremap("<leader>gvh",":Lspsaga hover_doc<CR>")

-- nmap("<C-n>", ":lua require'luasnip'.jump(-1)<Cr>")

-- " Easier Moving between splits")
nnoremap("<C-J>", "<C-W><C-J>")
nnoremap("<C-K>", "<C-W><C-K>")
nnoremap("<C-L>", "<C-W><C-L>")
nnoremap("<C-H>", "<C-W><C-H>")
-- " Make windows to be basically the same size")
nnoremap("<leader>=", " <C-w>=")
-- " Sizing window horizontally")
nnoremap("<c-,>", "<C-W><")
nnoremap("<c-.>", "<C-W>>")
nnoremap("<A-,>", "<C-W>5<")
nnoremap("<A-.>", "<C-W>5>")
-- " Sizing window vertically")
-- " taller")
nnoremap("<A-t>", "<C-W>+")
-- " shorter")
nnoremap("<A-s>", "<C-W>-")
