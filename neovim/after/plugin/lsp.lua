local lsp = require('lsp-zero').preset('recommended')

lsp.ensure_installed({
    'pylsp',
    'clangd',
})

lsp.configure('lua-language-server', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})


lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set('n', '<space>,', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  vim.keymap.set('n', '<space>;', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  vim.keymap.set('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  vim.keymap.set('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
  vim.keymap.set('n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>')
  vim.keymap.set('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
  vim.keymap.set('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
  vim.keymap.set('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
  vim.keymap.set('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
