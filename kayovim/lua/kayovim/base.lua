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

-- Oil
require('oil').setup {}
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { silent = true, desc = 'open parent directory' })

-- Snacks
local Snacks = require 'snacks'
vim.keymap.set('n', '<leader><leader>', function()
  Snacks.picker.smart()
end, { silent = true, desc = 'smart find' })
vim.keymap.set('n', '<leader>fg', function()
  Snacks.picker.grep()
end, { silent = true, desc = 'find grep' })
