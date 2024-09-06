--[[

======================================================================
==================== LEIA ISTO ANTES DE CONTINUAR ====================
======================================================================

Kickstart.nvim *NÃO* é uma distribuição.

Kickstart.nvim é um template para sua própria configuração.
  O objetivo é que você possa ler cada linha de código de cima à baixo,
  entender o que sua configuração está fazendo, e modificar-la para suas necessidades.

  Uma vez feito isso, você deveria começar a explorar, configurar e mexer no Neovim!

  Se você não sabe nada sobre lua, eu recomendo dar uma olhada em um guia
  Pore exemplo:
  - https://learnxinyminutes.com/docs/lua/


  E você pode explorar ou pesquisar `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart, o guia:

Eu deixei vários `:help X` comentários no init.lua
Você deve rodar aquele comando e ler a seção de ajuda para mais informação.

Também, eu tenho alguns items `NOTE:` no arquivo.
Estes são para você, o leitor, entender o que está acontecendo. Sinta-se livre para deletar-los
uma vez que você sabe o que está acontecendo, mas eles devem servir como um guia para quando você
encontrar algumas construções diferentes no seu nvim config.

Eu espero que você aproveite sua jornada no Neovim
`I hope you enjoy your Neovim journey`,
- TJ

P.S. Você pode deltar isso quando terminar. É sua configuração agora :)
--]] -- Coloque <space> como a tecla `leader`
-- Veja `:help mapleader`
--  NOTE: Precisa ser feito ANTES dos plugins serem requisitados (ou então o leader errado será usado)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Instalar `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` para mais informações
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn
        .system {'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', -- último release estável
                 lazypath}
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configurar plugins ]]
-- NOTE: Aqui é onde você consegue instalar seus plugins.
--  Você pode configurar plugins usando a tecla `config`.
--
--  Você pode também configurar plugins depois da chamada do setup,
--    já que eles irão está disponíveis no runtime neovim .
require('lazy').setup({
    -- NOTE: Primeiro, alguns plugins não precisam de nenhuma configuração

    -- Plugins relacionados ao Git
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    -- Detecta tabstop e shiftwidth automaticamente
    'tpope/vim-sleuth',

    -- NOTE: Aqui é onde seus plugins relacionados ao LSP podem ser instalados.
    --  A configuração está pronta abaixo. Procure por lspconfig para encontra-la.

    -- Configuração do LSP e Plugins
    'neovim/nvim-lspconfig',
    dependencies = { -- Automaticamente instala LSPs do stdpath para o neovim
    'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim', -- Updates de status úteis para o LSP
    -- NOTE: `opts = {}` é o mesmo que chamar `require('fidget').setup({})`
    {
        'j-hui/fidget.nvim',
        opts = {}
    }, -- Configuração lua adicional, faz umas paradas incríveis no neovim!
    'folke/neodev.nvim'}
}, {
    -- Autocomplete
    'hrsh7th/nvim-cmp',
    dependencies = { -- Snippet Engine e sua associação com o nvim-cmp
    'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip',

    -- Adiciona a LSP completion capabilities(capaciadades de completar)
    'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-path', -- Adiciona um número de snippets amigáveis ao usuário
    'rafamadriz/friendly-snippets'}
}, -- Plugins úteis para mostrar seus mapeamentos de teclas pendentes
{
    'folke/which-key.nvim',
    opts = {}
}, {
    -- Adiciona sinais ligados ao git par o gutter, como também suas facilidades para gerenciar mudanças
    'lewis6991/gitsigns.nvim',
    opts = {
        -- Veja `:help gitsigns.txt`
        signs = {
            add = {
                text = '+'
            },
            change = {
                text = '~'
            },
            delete = {
                text = '_'
            },
            topdelete = {
                text = '‾'
            },
            changedelete = {
                text = '~'
            }
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navegação
            map({'n', 'v'}, ']c', function()
                if vim.wo.diff then
                    return ']c'
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return '<Ignore>'
            end, {
                expr = true,
                desc = 'Jump to next hunk'
            })

            map({'n', 'v'}, '[c', function()
                if vim.wo.diff then
                    return '[c'
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return '<Ignore>'
            end, {
                expr = true,
                desc = 'Jump to previous hunk'
            })

            -- Ações
            -- Modo visual
            map('v', '<leader>hs', function()
                gs.stage_hunk {vim.fn.line '.', vim.fn.line 'v'}
            end, {
                desc = 'stage git hunk'
            })
            map('v', '<leader>hr', function()
                gs.reset_hunk {vim.fn.line '.', vim.fn.line 'v'}
            end, {
                desc = 'reset git hunk'
            })
            -- Modo normal
            map('n', '<leader>hs', gs.stage_hunk, {
                desc = 'git stage hunk'
            })
            map('n', '<leader>hr', gs.reset_hunk, {
                desc = 'git reset hunk'
            })
            map('n', '<leader>hS', gs.stage_buffer, {
                desc = 'git Stage buffer'
            })
            map('n', '<leader>hu', gs.undo_stage_hunk, {
                desc = 'undo stage hunk'
            })
            map('n', '<leader>hR', gs.reset_buffer, {
                desc = 'git Reset buffer'
            })
            map('n', '<leader>hp', gs.preview_hunk, {
                desc = 'preview git hunk'
            })
            map('n', '<leader>hb', function()
                gs.blame_line {
                    full = false
                }
            end, {
                desc = 'git blame line'
            })
            map('n', '<leader>hd', gs.diffthis, {
                desc = 'git diff against index'
            })
            map('n', '<leader>hD', function()
                gs.diffthis '~'
            end, {
                desc = 'git diff against last commit'
            })

            -- Liga/Desliga
            map('n', '<leader>tb', gs.toggle_current_line_blame, {
                desc = 'toggle git blame line'
            })
            map('n', '<leader>td', gs.toggle_deleted, {
                desc = 'toggle git show deleted'
            })

            -- Objeto de texto
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {
                desc = 'select git hunk'
            })
        end
    }
}, {
    -- Tema inspirado no Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
        vim.cmd.colorscheme 'onedark'
    end
}, {
    -- Setar lualine como statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
        options = {
            icons_enabled = false,
            theme = 'onedark',
            component_separators = '|',
            section_separators = ''
        }
    }
}, {
    -- Adiciona guias de indentação mesmo em linhas vazias
    'lukas-reineke/indent-blankline.nvim',
    -- Habilita `lukas-reineke/indent-blankline.nvim`
    -- Veja `:help ibl`
    main = 'ibl',
    opts = {}
}, -- "gc" para comentar regiões/linhas
{
    'numToStr/Comment.nvim',
    opts = {}
}, -- Fuzzy Finder (arquivos, lsp, etc)
{
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {'nvim-lua/plenary.nvim',
    -- O Algorítimo Fuzzy Finder necessita de dependencias locais para ser construído.
    -- Somente carrega se `make` está disponível. Tenha certeza que você tem os requisitos
    -- do sistema instalados
                    {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: Se você está tendo problemas com essa instalação,
        --       procure no README por telescope-fzf-native para mais instruções.
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end
    }}
}, {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {'nvim-treesitter/nvim-treesitter-textobjects'},
    build = ':TSUpdate'
}, -- NOTE: O Próximo Passo na sua Jornada Neovim: Adicionar/Configurar "plugins" adicionais para o kickstart
--       Aqui estão alguns exemplos de plugins que eu inclí no repositório do kickstart.
--       Descomente qualquer uma das linhas abaixo para ativa-los.
-- require 'kickstart.plugins.autoformat',
-- require 'kickstart.plugins.debug',
-- NOTE: O import abaixo pode automaticamente adicionar seus próprios plugins, configurações, etc. de `lua/custom/plugins/*.lua`
--    Você pode usar esse diretório para previnir qualquer conflito com este  init.lua se você está interessado em mante-lo
--    atualizado com o que estiver no repositório do kistarter-pt-br.
--    Descomente a seguinte linha e adiciona seus plugins para `lua/custom/plugins/*.lua` para avançar.
--
--    Para informações adicionais veja: https://github.com/folke/lazy.nvim#-structuring-your-plugins
{
    import = 'custom.plugins'
}, {})

-- [[ Setting options ]]
-- Veja `:help vim.o`
-- NOTE: Você pode mudar essas opções como desejar!

-- Setar highlight na pesquisa
vim.o.hlsearch = false

-- Faz o linhas com números padrão
vim.wo.number = true

-- Habilita modo mouse
vim.o.mouse = 'a'

-- Sincroniza a área de transferência entre o SO e o Neovim.
--  Remova está opção se você quer quer a área de transferência do SO seja independente.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Habilita break indent
vim.o.breakindent = true

-- Salva o undofile (arquivo de desfazer)
vim.o.undofile = true

-- Pesquisa de caso insensitivo A MENOS que \C ou uma letra em caixa alta esteja na pesquisa
vim.o.ignorecase = true
vim.o.smartcase = true

-- Manter signcolumn como padrão
vim.wo.signcolumn = 'yes'

-- Reduz o tempo de autalização
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Seta completeopt para ter uma melhor experiencia de complete
vim.o.completeopt = 'menuone,noselect'

-- NOTE: Você deveria fazer seu terminal suportar isso
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Mapeamento de teclas para uma melhor experiência padrão
-- Veja `:help vim.keymap.set()`
vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', {
    silent = true
})

-- Remapeia para lidar com word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", {
    expr = true,
    silent = true
})
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", {
    expr = true,
    silent = true
})

-- Mapeamento de tecla para Diagnostic
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {
    desc = 'Go to previous diagnostic message'
})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {
    desc = 'Go to next diagnostic message'
})
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {
    desc = 'Open floating diagnostic message'
})
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, {
    desc = 'Open diagnostics list'
})

-- [[ Highlight no yank ]]
-- Ver `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', {
    clear = true
})
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*'
})

-- [[ Configurando Telescope ]]
-- Ver `:help telescope` e `:help telescope.setup()`
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false
            }
        }
    }
}

-- Habilita telescope fzf native, se instalado
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep na raiz git
-- Função para encontrar a raiz git do repositório baseado no caminho do buffer atual
local function find_git_root()
    -- Usa o caminho do buffer atual como ponto de inicío para a busca git
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir
    local cwd = vim.fn.getcwd()
    -- Se o buffer não está associado com o arquivo retorna nil
    if current_file == '' then
        current_dir = cwd
    else
        -- Extrai o diretório do caminho atual do arquivo
        current_dir = vim.fn.fnamemodify(current_file, ':h')
    end

    -- Encontra o diretório git do caminho atual do arquivo
    local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
    if vim.v.shell_error ~= 0 then
        print 'Not a git repository. Searching on current working directory'
        return cwd
    end
    return git_root
end

-- Função live_grep customizada para procurar na raiz do git
local function live_grep_git_root()
    local git_root = find_git_root()
    if git_root then
        require('telescope.builtin').live_grep {
            search_dirs = {git_root}
        }
    end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- Ver `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, {
    desc = '[?] Find recently opened files'
})
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, {
    desc = '[ ] Find existing buffers'
})
vim.keymap.set('n', '<leader>/', function()
    -- Você pode passar configurações adicionais para o telescope mudar tema, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false
    })
end, {
    desc = '[/] Fuzzily search in current buffer'
})

local function telescope_live_grep_open_files()
    require('telescope.builtin').live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files'
    }
end
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, {
    desc = '[S]earch [/] in Open Files'
})
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, {
    desc = '[S]earch [S]elect Telescope'
})
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, {
    desc = 'Search [G]it [F]iles'
})
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, {
    desc = '[S]earch [F]iles'
})
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, {
    desc = '[S]earch [H]elp'
})
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, {
    desc = '[S]earch current [W]ord'
})
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, {
    desc = '[S]earch by [G]rep'
})
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', {
    desc = '[S]earch by [G]rep on Git Root'
})
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, {
    desc = '[S]earch [D]iagnostics'
})
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, {
    desc = '[S]earch [R]esume'
})

-- [[ Configurar Treesitter ]]
-- Ver `:help nvim-treesitter`
-- Adiar o setup do Treesitter para depois da primeira renderização para melhorar o tempo de inicialização do 'nvim {filename}'
vim.defer_fn(function()
    require('nvim-treesitter.configs').setup {
        -- Adicione linguagens para serem instaladas aqui que você quer que sejam instaladas no treesitter
        ensure_installed = {'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc',
                            'vim', 'bash'},

        -- Auto instala linguagens que não estão instaladas. Padrão sendo falso (mas você pode mudar para você mesmo)
        auto_install = false,

        highlight = {
            enable = true
        },
        indent = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<c-space>',
                node_incremental = '<c-space>',
                scope_incremental = '<c-s>',
                node_decremental = '<M-space>'
            }
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- Automaticamente pula para textobj, parecido com targets.vim
                keymaps = {
                    -- Você pode usar para capturar grupos definidos em textobjects.com
                    ['aa'] = '@parameter.outer',
                    ['ia'] = '@parameter.inner',
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner'
                }
            },
            move = {
                enable = true,
                set_jumps = true, -- Se setar jumps(pulos) na jumplist(lista de pulos)
                goto_next_start = {
                    [']m'] = '@function.outer',
                    [']]'] = '@class.outer'
                },
                goto_next_end = {
                    [']M'] = '@function.outer',
                    [']['] = '@class.outer'
                },
                goto_previous_start = {
                    ['[m'] = '@function.outer',
                    ['[['] = '@class.outer'
                },
                goto_previous_end = {
                    ['[M'] = '@function.outer',
                    ['[]'] = '@class.outer'
                }
            },
            swap = {
                enable = true,
                swap_next = {
                    ['<leader>a'] = '@parameter.inner'
                },
                swap_previous = {
                    ['<leader>A'] = '@parameter.inner'
                }
            }
        }
    }
end, 0)

-- [[ Configurar LSP ]]
--  Esta função roda quando um LSP conecta com um buffer específico.
local on_attach = function(_, bufnr)
    -- NOTE: Lembre-se que lua é uma linguagem de progração de verdade, então é possível
    -- definir pequenas funções util e helper para que você não tenha que ficar repetindo
    -- muitas vezes.
    --
    -- Neste caso, nós criamos a função que deixa-nos definir mapeamento mais facilmente
    -- para itens relacionados ao LSP. Ela seta o modo, buffer e descrição para nós cada vez.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, {
            buffer = bufnr,
            desc = desc
        })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- Veja `:help K` para descobrir por que repear isso
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Funcionalidades LSP menos usada
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Cria um comando `:Format` local para o buffer LSP
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, {
        desc = 'Format current buffer with LSP'
    })
end

-- documenta cadeia de teclas existentes
require('which-key').register {
    ['<leader>c'] = {
        name = '[C]ode',
        _ = 'which_key_ignore'
    },
    ['<leader>d'] = {
        name = '[D]ocument',
        _ = 'which_key_ignore'
    },
    ['<leader>g'] = {
        name = '[G]it',
        _ = 'which_key_ignore'
    },
    ['<leader>h'] = {
        name = 'Git [H]unk',
        _ = 'which_key_ignore'
    },
    ['<leader>r'] = {
        name = '[R]ename',
        _ = 'which_key_ignore'
    },
    ['<leader>s'] = {
        name = '[S]earch',
        _ = 'which_key_ignore'
    },
    ['<leader>t'] = {
        name = '[T]oggle',
        _ = 'which_key_ignore'
    },
    ['<leader>w'] = {
        name = '[W]orkspace',
        _ = 'which_key_ignore'
    }
}
-- registra which-key em VISUAL mode
-- necessário para visual <leader>hs (hunk stage) para funcionar
require('which-key').register({
    ['<leader>'] = {
        name = 'VISUAL <leader>'
    },
    ['<leader>h'] = {'Git [H]unk'}
}, {
    mode = 'v'
})

-- mason-lspconfig precisa que estas funções setup sejam chamadas nesta ordem
-- antes de setar os servidores.
require('mason').setup()
require('mason-lspconfig').setup()

-- Habilita os seguintes language servers
--  Sinta-se livre par adicionar/remover qualuqer LSP que você queira aqui. Eles irão automaticamente ser instalados.
--
--  Adicione qualquer override adicional nas tabelas seguintes. Elas irão ser passadas para
--  o campo `settings`das configurações do servidor. You must look up that documentation yourself.
--
--  Se você quer sobreescrever os tipos de arquivos padrões que seu language server irá anexar você
--  Definir a propriedade  'filetypes' para mapear a questão.
local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},
    -- html = { filetypes = { 'html', 'twig', 'hbs'} },

    lua_ls = {
        Lua = {
            workspace = {
                checkThirdParty = false
            },
            telemetry = {
                enable = false
            }
            -- NOTE: Habilita abaixo para ignorar as irritantes warinings `missing-fields` LUA_LS
            -- diagnostics = { disable = { 'missing-fields' } },
        }
    }
}

-- Setup da configuração neovim lua 
require('neodev').setup()

-- nvim-cmp suporta capabilities(capacidades) de complete adidionais, que transmitem ela para outros
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Garanta os servidores acima que vão ser instaloes
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers)
}

mason_lspconfig.setup_handlers {function(server_name)
    require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
        filetypes = (servers[server_name] or {}).filetypes
    }
end}

-- [[ Configurar nvim-cmp ]]
-- Ver `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, {'i', 's'}),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {'i', 's'})
    },
    sources = {{
        name = 'nvim_lsp'
    }, {
        name = 'luasnip'
    }, {
        name = 'path'
    }}
}

-- import configuração customizada
require 'custom.core'
-- A linha abaixo disso é chamada `modeline`. Veja `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
