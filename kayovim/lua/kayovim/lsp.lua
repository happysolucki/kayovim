vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  },
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}

vim.lsp.config('efm', {
  filetypes = { 'lua', 'nix' },
  init_options = { documentFormatting = true },
  settings = {
    languages = {
      nix = { require 'efmls-configs.formatters.nixfmt', require 'efmls-configs.linters.statix' },
      lua = { require 'efmls-configs.formatters.stylua' },
    },
  },
})

vim.lsp.enable 'lua_ls'
vim.lsp.enable 'eslint'
vim.lsp.enable 'efm'
vim.lsp.enable 'nixd'

local lsp_fmt_group = vim.api.nvim_create_augroup('LspFormattingGroup', {})
vim.api.nvim_create_autocmd('BufWritePost', {
  group = lsp_fmt_group,
  callback = function(ev)
    local efm = vim.lsp.get_clients { name = 'efm', bufnr = ev.buf }

    if vim.tbl_isempty(efm) then
      return
    end

    vim.lsp.buf.format { name = 'efm' }
  end,
})
