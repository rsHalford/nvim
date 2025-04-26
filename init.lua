local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

_G.Config = {}

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Settings, mappings, functions, and autocmds
now(function() require('settings') end)
now(function() require('mappings') end)
now(function() require('functions') end)
now(function() require('autocmds') end)

add({ name = 'mini.nvim' })

now(function()
  add('rebelot/kanagawa.nvim')
  require('kanagawa').setup({
    compile = true,
    undercurl = true,
    transparent = true,
    dimInactive = false,
    colors = {
      theme = {
        all = { ui = { bg_gutter = 'none' } },
      },
    },
    background = { -- map the value of 'background' option to a theme
      dark = 'wave',
    },
    commentStyle = { bold = true, italic = true },
    functionStyle = { bold = true, italic = false },
    keywordStyle = { bold = true, italic = false },
    statementStyle = { bold = true, italic = false },
    typeStyle = { bold = false, italic = true },
  })
end)

now(function() vim.cmd('colorscheme kanagawa') end)

now(
  function()
    require('mini.basics').setup({
      options = { extra_ui = true, win_borders = 'single' },
      mappings = { windows = true },
    })
  end
)

now(function() require('mini.sessions').setup() end)
now(function() require('mini.statusline').setup() end)

now(function()
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
  })
  MiniIcons.mock_nvim_web_devicons()
  later(MiniIcons.tweak_lsp_king)
end)

later(function() require('mini.extra').setup() end)

later(function()
  local ai = require('mini.ai')
  ai.setup({
    custom_textobjects = {
      B = MiniExtra.gen_ai_spec.buffer(),
      F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
    },
  })
end)

later(function() require('mini.bracketed').setup() end)

later(function() require('mini.bufremove').setup() end)

later(function()
  local clue = require('mini.clue')

  clue.setup({
    clues = {
      Config.leader_group_clues,
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
    },

    triggers = {
      { mode = 'n', keys = '<Leader>' }, -- Leader triggers
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = [[\]] }, -- mini.basics
      { mode = 'n', keys = '[' }, -- mini.bracketed
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' }, -- Built-in completion
      { mode = 'n', keys = 'g' }, -- `g` key
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" }, -- Marks
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' }, -- Registers
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' }, -- Window commands
      { mode = 'n', keys = 'z' }, -- `z` key
      { mode = 'x', keys = 'z' },
    },

    window = { config = { border = 'single', width = 'auto' } },
  })
end)

later(function() require('mini.comment').setup() end)

now(function()
  require('mini.completion').setup({
    window = {
      info = { border = 'single' },
      signature = { border = 'single' },
    },
  })
  -- TODO: remove once on 0.11
  if vim.fn.has('nvim-0.11') == 1 then
    vim.opt.completeopt:append('fuzzy') -- Use fuzzy matching for built-in completion
  end
end)

later(function() require('mini.cursorword').setup() end)

later(
  function()
    require('mini.diff').setup({
      mappings = {
        apply = '<leader>ga',
        reset = '<leader>gr',
      },
    })
  end
)

later(
  function()
    require('mini.files').setup({
      mappings = {
        close = '<Esc>',
      },
      windows = { preview = true },
    })
  end
)

later(function() require('mini.git').setup() end)

later(function()
  local hipatterns = require('mini.hipatterns')
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
      hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
      todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
      note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),

      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

later(function() require('mini.jump').setup() end)

later(function()
  require('mini.misc').setup({ make_global = {
    'put',
    'put_text',
    'stat_summary',
    'bench_time',
  } })
  MiniMisc.setup_auto_root()
  MiniMisc.setup_termbg_sync()
end)

later(
  function()
    require('mini.operators').setup({
      evaluate = { prefix = '<Leader>o=' },
      exchange = { prefix = '<Leader>ox' },
      multiply = { prefix = '<Leader>om' },
      replace = { prefix = '<Leader>or' },
      sort = { prefix = '<Leader>os' },
    })
  end
)

later(function()
  require('mini.pick').setup({
    mappings = {
      toggle_info = '<C-k>',
    },
  })
end)

later(function()
  local snippets = require('mini.snippets')
  local gen_loader = snippets.gen_loader
  local config_path = vim.fn.stdpath('config')

  snippets.setup({
    snippets = {
      gen_loader.from_file(config_path .. '/snippets/global.json'),
      gen_loader.from_lang(),
    },

    -- NOTE: below mapping does not currently work
    -- mapping = {
    --   jump_next = '<C-n>',
    --   jump_prev = '<C-p>',
    -- },
  })

  MiniSnippets.start_lsp_server()
end)

later(function() require('mini.splitjoin').setup() end)

later(function() require('mini.surround').setup() end)

later(function() require('mini.trailspace').setup() end)

later(function() require('mini.visits').setup() end)

later(function()
  add('mfussenegger/nvim-lint')
  local lint = require('lint')

  lint.linters_by_ft = {
    css = { 'biomejs' },
    elixir = { 'credo' },
    go = { 'golangcilint' },
    javascript = { 'biomejs' },
    -- json = { 'jsonlint' },
    nix = { 'nix' },
    ruby = { 'rubocop' },
    sh = { 'shellcheck' },
  }

  local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
    group = lint_augroup,
    callback = function() lint.try_lint() end,
  })
end)

local now_if_args = vim.fn.argc(-1) > 0 and now or later

now_if_args(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
  })
  add('nvim-treesitter/nvim-treesitter-textobjects')

  local ensure_installed = {
    'bash',
    'c',
    'cpp',
    'css',
    'go',
    'html',
    'javascript',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'regex',
    'rust',
    'toml',
    'tsx',
    'yaml',
    'vim',
    'vimdoc',
    'zig',
  }

  require('nvim-treesitter.configs').setup({
    ensure_installed = ensure_installed,
    highlight = { enable = true },
    incremental_selection = { enable = false },
    textobjects = { enable = false },
    indent = { enable = false },
  })

  -- Disable injections in 'lua' language
  local ts_query = require('vim.treesitter.query')
  local ts_query_set = vim.fn.has('nvim-0.9') == 1 and ts_query.set or ts_query.set_query
  ts_query_set('lua', 'injections', '')
end)

later(function()
  add('stevearc/conform.nvim')

  require('conform').setup({
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },

    formatters_by_ft = {
      css = { 'biome' },
      elixir = { 'mix' },
      go = { 'goimports', 'gofmt' },
      javascript = { 'biome' },
      json = { 'jq' },
      lua = { 'stylua' },
      nix = { 'nixfmt' },
      ocaml = { 'ocamlformat' },
      sh = { 'shfmt' },
      sql = { 'sql_formatter' },
      toml = { 'taplo' },
      yaml = { 'yq' },
      zig = { 'zigfmt' },
      ['_'] = { 'trim_whitespace' },
    },

    formatters = {},
  })
end)

now_if_args(function()
  add('neovim/nvim-lspconfig')

  local custom_on_attach = function(client, buf_id)
    vim.bo[buf_id].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

    if client.supports_method({ method = 'code_lens' }) then
      local codelens = vim.api.nvim_create_augroup('LSPCodeLens', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'CursorHold' }, {
        group = codelens,
        callback = function() vim.lsp.codelens.refresh() end,
        buffer = buf_id,
      })
    end
  end

  local lspconfig = require('lspconfig')

  lspconfig.elixirls.setup({ on_attach = custom_on_attach })

  lspconfig.gopls.setup({
    on_attach = custom_on_attach,
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  })

  lspconfig.lua_ls.setup({
    on_attach = function(client, bufnr)
      custom_on_attach(client, bufnr)

      client.server_capabilities.completionProvider.triggerCharacters = { '.', ':' }
    end,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          globals = {
            'vim',
            'describe',
            'it',
            'before_each',
            'after_each',
            'MiniCompletion',
            'MiniDeps',
            'MiniExtra',
            'MiniIcons',
            'MiniMisc',
            'MiniPick',
            'MiniSnippets',
          },
        },
        workspace = {
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  })

  lspconfig.ocamllsp.setup({
    on_attach = function(client, bufnr) custom_on_attach(client, bufnr) end,
    settings = {
      codelens = { enable = true },
      syntaxDocumentation = { enable = true },
    },
  })

  lspconfig.taplo.setup({ on_attach = custom_on_attach })
  lspconfig.templ.setup({ on_attach = custom_on_attach })
  lspconfig.zls.setup({ on_attach = custom_on_attach })
end)

later(function() add('rafamadriz/friendly-snippets') end)

-- vim: ts=2 sts=2 sw=2 et
