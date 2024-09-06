-- Arquivo de configuração para LazyVim no macOS: ~/.config/nvim/lua/keymaps.lua
local keymap = vim.keymap.set

-- Atalhos essenciais do VSCode adaptados para LazyVim/Neovim com Command no macOS

-- ⌘ + P -> Abrir arquivos rapidamente (Telescope find files)
keymap('n', '<Cmd>p', ':Telescope find_files<CR>', {
    noremap = true,
    silent = true
})

-- ⌘ + Shift + P -> Abrir o Command Palette (Telescope commands)
keymap('n', '<Cmd><S-p>', ':Telescope commands<CR>', {
    noremap = true,
    silent = true
})

-- ⌘ + B -> Alternar barra lateral (NERDTree ou Neo-tree)
keymap('n', '<Cmd>b', ':NvimTreeToggle<CR>', {
    noremap = true,
    silent = true
})

-- ⌘ + Shift + E -> Focar no explorador de arquivos
keymap('n', '<Cmd><S-e>', ':NvimTreeFindFile<CR>', {
    noremap = true,
    silent = true
})

-- ⌘ + F -> Buscar texto no arquivo atual
keymap('n', '<Cmd>f', ':Telescope current_buffer_fuzzy_find<CR>', {
    noremap = true,
    silent = true
})

-- ⌘ + Shift + F -> Buscar em todos os arquivos (live grep)
keymap('n', '<Cmd><S-f>', ':Telescope live_grep<CR>', {
    noremap = true,
    silent = true
})

-- ⌘ + G -> Ir para uma linha específica
keymap('n', '<Cmd>g', ':Telescope lsp_definitions<CR>', {
    noremap = true,
    silent = true
})

-- ⌘ + D -> Selecionar a próxima ocorrência da seleção
keymap('n', '<Cmd>d', 'viw"zy:Telescope grep_string<CR>', {
    noremap = true,
    silent = true
})

-- Option + Up/Down -> Mover linha ou seleção para cima/baixo
keymap('n', '<A-Up>', ':m .-2<CR>==', {
    noremap = true,
    silent = true
})
keymap('n', '<A-Down>', ':m .+1<CR>==', {
    noremap = true,
    silent = true
})

-- ⌘ + / -> Comentar/Descomentar linha ou seleção (usando o plugin Comment.nvim)
keymap('n', '<Cmd>/', 'gcc', {
    noremap = true,
    silent = true
})
keymap('v', '<Cmd>/', 'gc', {
    noremap = true,
    silent = true
})

-- ⌘ + K, ⌘ + S -> Abrir atalhos de teclado (LazyVim configurado)
keymap('n', '<Cmd>k<Cmd>s', ':Telescope keymaps<CR>', {
    noremap = true,
    silent = true
})

-- ⌘ + W -> Fechar a janela (split)
keymap('n', '<Cmd>w', ':close<CR>', {
    noremap = true,
    silent = true
})

-- ⌘ + T -> Abrir um terminal integrado
keymap('n', '<Cmd>t', ':ToggleTerm<CR>', {
    noremap = true,
    silent = true
})
