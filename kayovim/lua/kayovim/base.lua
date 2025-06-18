vim.keymap.set('n', '<Space>', '<Nop>', { silent = true, remap = false })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.mouse = 'a'

vim.o.number = true
vim.o.relativenumber = true
vim.o.smartindent = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 0 -- use tabstop
vim.o.scrolloff = 8

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = false

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.termguicolors = true
vim.o.showmode = false

require('lazydev').setup {
  library = {
    -- See the configuration section for more details
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

require('mini.icons').setup {}
require('mini.files').setup {}
require('mini.pick').setup {}
require('mini.statusline').setup {}

local minifiles_toggle = function(...)
  if not MiniFiles.close() then
    MiniFiles.open(...)
  end
end

vim.keymap.set('n', '-', minifiles_toggle, { silent = true, desc = 'Open file explorer' })
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', { silent = true, desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<cr>', { silent = true, desc = 'Grep' })
