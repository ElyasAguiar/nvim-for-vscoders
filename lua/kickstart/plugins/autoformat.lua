-- autoformat.lua
--
-- Use seu language server para formatar automaticamente seu código ao salvar.
-- Também use comandos adicionais para lidar com esse comportamento

return {
  'neovim/nvim-lspconfig',
  config = function()
    -- Troque para controlar o que você quiser quando quiser autoformatar.
    --  Use :KickstartFormatToggle para habilitar ou desabilitar a autoformatação
    local format_is_enabled = true
    vim.api.nvim_create_user_command('KickstartFormatToggle', function()
      format_is_enabled = not format_is_enabled
      print('Setting autoformatting to: ' .. tostring(format_is_enabled))
    end, {})

    -- Crie um augroup para gerenciar sua automação 'autocmds' de formatação.
    --      Precisamos de pelo menos um augroup por cliente para termos certeza que
    --      multiplos clientes podem anexar ao mesmo buffer sem interferirem entre si
    local _augroups = {}
    local get_augroup = function(client)
      if not _augroups[client.id] then
        local group_name = 'kickstart-lsp-format-' .. client.name
        local id = vim.api.nvim_create_augroup(group_name, { clear = true })
        _augroups[client.id] = id
      end

      return _augroups[client.id]
    end

    -- Quando um LSP anexa ao buffer, nós iremos retornar essa função.
    --
    -- Veja `:help LspAttach` para mais informações sobre o evento autocmd.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
      -- Isso é onde nós anexamos a autoformação para para clientes "razoáveis"
      callback = function(args)
        local client_id = args.data.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local bufnr = args.buf

        -- Somente anexe aos clientes que suportam formação de documentos
        if not client.server_capabilities.documentFormattingProvider then
          return
        end

        -- Tsserver normalmente funciona mal. Sinto muito se você trabalha com linguagens ruins
        -- Vocẽ pode remover essa linha se você sabe o que está fazendo :)
        if client.name == 'tsserver' then
          return
        end

        -- Crie um autocmd que irá rodar *antes* de nós salvarmos o buffer.
        --  Rode o comando de formatação para o LSP que anexamos.
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = get_augroup(client),
          buffer = bufnr,
          callback = function()
            if not format_is_enabled then
              return
            end

            vim.lsp.buf.format {
              async = false,
              filter = function(c)
                return c.id == client.id
              end,
            }
          end,
        })
      end,
    })
  end,
}
