-- debug.lua
--
-- Mostra como usar um plugin DAP para debugar seu código
--
-- Principalmente focado em configurar o debugger para Go, mas pode ser
-- extendido para outras linguagens também. Por isso que chamamos de
-- kickstart-pt-br.nvim e não quer-um-marido.nvim ;)

return {
  -- NOTE: Sim, você também pode instalar novos plugins aqui!
  'mfussenegger/nvim-dap',
  -- NOTE: E você pode especificar dependencias também
  dependencies = {
    -- Cria uma interface maravilhosa
    'rcarriga/nvim-dap-ui',

    -- Instale os debug adapters para você
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Adicione seus próprios debugger aqui
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Faça o seu melhor para ajeitar os vários 
      -- debuggers com uma configuração boa
      automatic_setup = true,

      -- Você pode fornecer configuração adicional para os handlers,
      -- veja o README mason-nvim-dap para mais informações
      handlers = {},

      -- Você irá precisar ver o que você tem que precisa instalar online
      -- por favor, não me pergunte como instala-los :)
      ensure_installed = {
        -- Atualize para garantir que você tem os debuggers para as linguagens que você quer
        'delve',
      },
    }

    -- Mapeamento de téclas báscio para debugging, sinta-se livre para mudar para o que você gosta!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Passo à passo Dap UI
    -- Para mais informações veja |:help nvim-dap-ui|
    dapui.setup {
      -- Coloque ícones para caracteres que são mais prováveis de funcionar em qualquer terminal.
      --    Sinta-se livre para remover ou usar os que você mais gosta :)
      --    Não sinta-se como se fossem boas escolhas.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Habilite para ver o resultado da última sessão. Sem isso, você não pode ver o output em caso de uma unhandled exeption(erro).
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Instale a configuração específica para golang
    require('dap-go').setup()
  end,
}
