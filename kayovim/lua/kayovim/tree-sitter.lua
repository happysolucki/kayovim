require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    disable = { 'bigfile' },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['ia'] = { query = '@parameter.inner', desc = 'inner argument' },
        ['aa'] = { query = '@parameter.outer', desc = 'around argument' },
      },
    },
  },
}

require('treesitter-context').setup {
  enable = true,
  max_lines = 4,
}
