# kickstart-pt-br.nvim

https://github.com/kdheepak/kickstart-pt-br.nvim/assets/1813121/f3ff9a2b-c31f-44df-a4fa-8a0d7b17cf7b

### Introdução

Um ponto de partida para o neovim:

* Pequeno
* Arquivos únicos (com exemplos para tornar-se multi-arquivos)
* Documentado
* Modular

Este repositório é para ser usado por **VOCÊ** para começar sua jornada no neovim; remova coisas que você não usa e adicione o que sente falta

kickstart-pt-br.nvim é referente *somente* a ultima versão ['estável'](https://github.com/neovim/neovim/releases/tag/stable) e a última ['nightly'](https://github.com/neovim/neovim/releases/tag/nightly) do Neovim. Se voê tem algum problema, por favor certifique-se de usar as últimas versões.

Alternativas de Distribuição:
- [LazyVim](https://www.lazyvim.org/): Uma incrível distribuição mantida pelo @folke (o autor do lazy.nvim, o gerenciador de pacotes usado aqui)

### Instação

> **NOTAS** 
> [Backup](#FAQ) das suas configurações anteriores (se existiriem)

Requisitos:
* Certifique-se de revisar os readmes dos plugins que você está tendo erros. Principalmente:
  * [ripgrep](https://github.com/BurntSushi/ripgrep#installation) é necessário para muitos [telescope](https://github.com/nvim-telescope/telescope.nvim#suggested-dependencies) pickers.
* Veja [Instalação no Windows](#Instalação-no-Windows) se você tem problemas com `telescope-fzf-native`

As configurações do Neovim estão localizadas dentro dos seguintes caminhos, dependendo do seu sistema operacional:

| OS | PATH |
| :- | :--- |
| Linux | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%userprofile%\AppData\Local\nvim\` |
| Windows (powershell)| `$env:USERPROFILE\AppData\Local\nvim\` |

Clone o kickstart-pt-br.nvim:

- no Linux e Mac
```sh
git clone https://github.com/ElyasAguiar/nvim-for-vscoders.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

- no Windows (cmd)
```
git clone https://github.com/ElyasAguiar/nvim-for-vscoders.git %userprofile%\AppData\Local\nvim\ 
```

- no Windows (powershell)
```
git clone https://github.com/ElyasAguiar/nvim-for-vscoders.git $env:USERPROFILE\AppData\Local\nvim\ 
```


### Pós-Instalação

Inicie o Neovim

```sh
nvim
```

O gerenciador de plugins `Lazy` irá inciar automaticamente quando rodar pela primeira vez e instalar os plugins configurados - como pode ser visto no vídeo de introdução. Depois da instação estar complete você pode pressionar `q` para fechar a interface do `Lazy` e **você já pode brincar**! Na próxima vez que você rodar o nvim `Lazy` não irá mais aparecer.

Se você preferir não fazer dessa forma, você pode rodar a sincronização dos plugins por linha de comando, você pode usar:

```sh
nvim --headless "+Lazy! sync" +qa
```

### Passos Recomendados

[Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) este repositório (para que você tenha sua própria cópia que possa modificar) e instale.
Você pode instalar na sua máquina utilizando os métodos acima.

> **NOTE**  
> A url do seu fork irá ser algo assim: `https://github.com/<your_github_username>/kickstart-pt-br.nvim.git`

### Configuração e Extensão

* Dentro da sua cópia, sinta-se livre para modificar qualquer arquivo que você goste! É a SUA cópia!
* Sinta-se livre para mudar qualquer opção padrão em `init.lua` para melhor atender suas necessidades.
* Para adicionar mais plugins, há 3 opção principais:
  * Adicionar novas configurações nos arquivos em `lua/custom/plugins/*`, que irá ser procurados automaticamente usando o `lazy.nvim` (descomente a linha importando o diretório `custom/plugins` no arquivo `init.lua` para habilitar isso)
  * Modifique `init.lua` com plugins adicionais.
  * Inclua os arquivos de `lua/kickstart/plugins/*` na sua configuração.

Você também pode mergear mudanças e atualizações deste repositório em seu fork, para manter-se atualizado com qualquer mudança na configuração padrão.

#### Example: Adicionando o plugin autopairs

No arquivo: `lua/custom/plugins/autopairs.lua`, adicione:

```lua
-- Arquivo: lua/custom/plugins/autopairs.lua

return {
  "windwp/nvim-autopairs",
  -- Dependencia opcional
  dependencies = { 'hrsh7th/nvim-cmp' },
  config = function()
    require("nvim-autopairs").setup {}
    -- Se você que automaticamente adicionar `(` depois de selecionar a função ou método
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
  end,
}
```


Isso irá automaticamente instalar [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs) e habilita-lo quando iniciar. Para mais informações, veja a documentação [lazy.nvim](https://github.com/folke/lazy.nvim).

#### Exemplo: Adicionando um plugin de arquivos em árvore

No arquivo: `lua/custom/plugins/filetree.lua`, adicione:

```lua
-- A menos que você ainda está migrando, remova os comandos depreciados da v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- não obrigatório, mas recomendado
    "MunifTanjim/nui.nvim",
  },
  config = function ()
    require('neo-tree').setup {}
  end,
}
```

Isso irá instalar o plugin de árvore e adicionar o comando `:Neotree` para você. A documentação pode ser explorada em [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) para mais informações.

### Contribuição

Pull-requests são bem vindos. O objetivo desse repositório não é criar um framework de configuração para o Neovim, mas oferecer um template para para começar que, por exemplo, mostre as funcionalidades no Neovim. Algumas coisas que não serão incluídas:

* Configuração customizada do language server (null-ls templates)
* Temas além do colorschema necessário para LSP highlight groups

Cada PR, especialmente aqueles que aumentam a quantidade de linhas, deve ter a descrição do por que o PR é necessário.

### FAQ

* O que eu deveria fazer se eu já tenho uma configuração existente do neovim?
  * Você deve fazer um backup e então deletar todos os arquivos ligados a configuração.
   * Isso inclui seu init.lua e os arquivos do neovim em `~/.local` que podem ser deletados com `rm -rf ~/.local/share/nvim/`
  * Você pode quer olhar em [migration guide for lazy.nvim](https://github.com/folke/lazy.nvim#-migration-guide)
* Posso manter minha configuração existente em paralelo com o kickstart?
  * Sim! Você pode usar [NVIM_APPNAME](https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME)`=nvim-NAME` para manter múltiplas configurações. Por exemplo você pode instalar a configuração do kickstart em `~/.config/nvim-kickstart` e criar um alias:
    ```
    alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
    ```
    Quando você roda o Neovim usando o alias`nvim-kickstart` irá usar o diretório de configurações alternativas e o diretório local `~/.local/share/nvim-kickstart`. Você pode aplicar essa abordagem par aqualquer distribuição Neovim que você gostaria de tentar.
* E se eu quiser "desinstalar" essa configuração:
  * Veja [lazy.nvim uninstall](https://github.com/folke/lazy.nvim#-uninstalling)
* Há algum vídeo legal sobre este plugin?
  * Atual interação do kickstart (em breve)
  * Aqui há uma interação antiga do kickstart(em inglês): [vídeo de introdução do kickstart-pt-br.nvim](https://youtu.be/stqUbv-5u2s). Note que intalar via init.lua não funciona como foi dito. Por favor siga os passos neste arquivo em vez disso, porque estão atualizadas.
* Por que o kickstart `init.lua` é um arquivo único? Não faria mais sentido dividir em múltiplos arquivos?
  * O propósito principal do kickstart é servir como uma ferramente de aprendizado e referência
    de configuração que alguém pode simplesmente fazer um `git clone` como base para a sua própria.
    Enquanto você progride aprendendo Neovim e Lua você pode considerar dividir seu `init.lua`
    em partes menores. Um fork do kickstart pode ser feito mantendo a exata funcionalidade em:
    * [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim)
  * Discussões sobre esse tópico podem ser encontradas em:
    * [Reestruture a configuração](https://github.com/nvim-lua/kickstart.nvim/issues/218)
    * [Reorganize init.lua em um passo à passo multi-arquivos](https://github.com/nvim-lua/kickstart.nvim/pull/473)

### Instalação no Windows

A instalação pode precisar de ferramentas de build, e atualizar o comando para rodar para `telescope-fzf-native`

Veja a documentação `telescope-fzf-native` para [mais detalhes](https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation)

È necessário:

- Instalar o CMake, e o Microsoft C++ Build Tools no Windows

```lua
{'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
```

