local map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

local L = function(key) return '<Leader>' .. key end
local C = function(cmd) return '<CMD>' .. cmd .. '<CR>' end

-- Leader mappings with definitions for mini.clue groups
_G.Config.leader_group_clues = {
  { mode = 'n', keys = L('g'), desc = 'Git' },
  { mode = 'n', keys = L('o'), desc = 'Operators' },
  { mode = 'n', keys = L('t'), desc = 'Toggle' },
  -- { mode = 'n', keys = L('v'), desc = 'Visits' },
}

-- TODO: Look into using similar to Harpoon
-- map({ 'n' }, L('h'), C('lua MiniExtra.pickers.visit_paths()'), 'Open visit paths picker')
-- map({ 'n' }, L('H'), C('lua MiniExtra.pickers.visit_labels()'), 'Open visit labels picker')

-- TODO: Organise
-- NOTE: Tab toggles preview, <C-k> general information about picker state
--stylua: ignore start
map({ 'n' }, 'gd',    C('lua MiniExtra.pickers.lsp({scope="definition"})'),       'Go to source definition')
map({ 'n' }, 'gD',    C('lua MiniExtra.pickers.lsp({scope="declaration"})'),      'Go to symbol declaration')
map({ 'n' }, 'gra',   C('lua vim.lsp.buf.code_action()'),                         'Perform code action')
map({ 'n' }, 'gri',   C('lua MiniExtra.pickers.lsp({scope="implementation"})'),   'Go to implementation')
map({ 'n' }, 'grn',   C('lua vim.lsp.buf.rename()'),                              'Rename symbol')
map({ 'n' }, 'grr',   C('lua MiniExtra.pickers.lsp({scope="references"})'),       'Go to references')
map({ 'n' }, 'gT',    C('lua MiniExtra.pickers.lsp({scope="type_definition"})'),  'Go to type definition')
map({ 'n' }, 'gs',    C('lua Config.new_scratch_buffer()'),                       'Go to scratch buffer')
map({ 'n' }, 'zS',    C('lua MiniExtra.pickers.spellsuggest()'),                  'Open spell suggestions picker')
map({ 'n' }, '-',     C('lua MiniFiles.open()'),                                  'Open parent directory')
map({ 'n' }, L('b'),  C('lua MiniPick.builtin.buffers()'),                        'Open buffers picker')
map({ 'n' }, L('c'),  C('lua MiniExtra.pickers.hipatterns()'),                    'Open comment picker')
map({ 'n' }, L('C'),  C('lua MiniExtra.pickers.commands()'),                      'Open commands picker')
map({ 'n' }, L('d'),  C('lua MiniExtra.pickers.diagnostic({scope="current"})'),   'Open diagnostics picker')
map({ 'n' }, L('D'),  C('lua MiniExtra.pickers.diagnostic({scope="all"})'),       'Open workspace diagnostics picker')
map({ 'n' }, L('f'),  C('lua MiniPick.builtin.files()'),                          'Open file picker')
map({ 'n' }, L('F'),  C('lua MiniExtra.pickers.git_files()'),                     'Open git file picker')
map({ 'n' }, L('gb'), C('lua MiniExtra.pickers.git_branches()'),                  'Open git branch picker')
map({ 'n' }, L('gc'), C('lua MiniExtra.pickers.git_commits()'),                   'Open git commit picker')
map({ 'n' }, L('gu'), C('lua Config.pick_modified_untracked()'),                  'Open uncommited file picker')
map({ 'n' }, L('h'),  C('lua MiniPick.builtin.help()'),                           'Open help picker')
map({ 'n' }, L('k'),  C('lua MiniExtra.pickers.keymaps()'),                       'Open keymap picker')
map({ 'n' }, L('u'),  C('lua MiniDeps.update()'),                                 'Update dependencies')
map({ 'n' }, L('p'),  C('lua MiniExtra.pickers.oldfiles()'),                      'Open previous files picker')
map({ 'n' }, L('s'),  C('lua MiniExtra.pickers.lsp({scope="document_symbol"})'),  'Open symbol picker')
map({ 'n' }, L('S'),  C('lua MiniExtra.pickers.lsp({scope="workspace_symbol"})'), 'Open workspace symbol picker')
map({ 'n' }, L('ti'), C('lua Config.toggle_inlay_hints()'),                       'Toggle inlay hints')
map({ 'n' }, L('tq'), C('lua Config.toggle_quickfix()'),                          'Toggle quickfix')
map({ 'n' }, L("'"),  C('lua MiniPick.builtin.resume()'),                         'Open last picker')
map({ 'n' }, L('"'),  C('lua MiniExtra.pickers.registers()'),                     'Open registers picker')
map({ 'n' }, L('/'),  C('lua MiniPick.builtin.grep_live()'),                      'Open ripgrep picker')
--stylua: ignore end

-- Subword navigation
map({ 'n', 'o', 'x' }, 'b', C([[lua require('spider').motion('b')]]))
map({ 'n', 'o', 'x' }, 'e', C([[lua require('spider').motion('e')]]))
map({ 'n', 'o', 'x' }, 'w', C([[lua require('spider').motion('w')]]))

-- Center next
map({ 'n' }, 'n', 'nzzzv', 'Centre next match')
map({ 'n' }, 'N', 'Nzzzv', 'Centre prev match')
map({ 'n' }, '<C-u>', '<C-u>zz', 'Centre prev up')
map({ 'n' }, '<C-d>', '<C-d>zz', 'Centre scroll down')

-- Undo breakpoints
map({ 'i' }, ',', ',<c-g>u', '')
map({ 'i' }, '.', '.<c-g>u', '')
map({ 'i' }, '?', '?<c-g>u', '')
map({ 'i' }, '!', '!<c-g>u', '')
map({ 'i' }, '[', '[<c-g>u', '')
map({ 'i' }, '{', '{<c-g>u', '')
map({ 'i' }, '(', '(<c-g>u', '')

-- Jumplist
map(
  { 'n' },
  'k',
  [[(v:count > 5 ? "m'" . v:count : "") . 'k']],
  '',
  { noremap = true, desc = 'Mark to jumplist', expr = true, silent = true }
)
map(
  { 'n' },
  'j',
  [[(v:count > 5 ? "m'" . v:count : "") . 'j']],
  '',
  { noremap = true, desc = 'Mark to jumplist', expr = true, silent = true }
)

-- Moving lines
map({ 'n' }, 'J', 'mzJ`z', 'Concatenate with line below')
map({ 'v' }, 'J', [[:m '>+1<CR>gv=gv]], 'Move selection down')
map({ 'v' }, 'K', [[:m '<-2<CR>gv=gv]], 'Move selection up')
map({ 'i' }, '<M-j>', '<ESC>:m .+1<CR>==', 'Move line down')
map({ 'i' }, '<M-k>', '<ESC>:m .-2<CR>==', 'Move line up')
map({ 'n' }, '<M-j>', function()
  if vim.opt.diff:get() then
    vim.cmd([[normal! ]c]])
  else
    vim.cmd([[m .+1<CR>==]])
  end
end, 'Move line down')
map({ 'n' }, '<M-k>', function()
  if vim.opt.diff:get() then
    vim.cmd([[normal! [c]])
  else
    vim.cmd([[m .-2<CR>==]])
  end
end, 'Move line up')

-- Stop typing them
map({ 'n' }, '<left>', C('echo "Use h to move"'), '')
map({ 'n' }, '<right>', C('echo "Use l to move"'), '')
map({ 'n' }, '<up>', C('echo "Use k to move"'), '')
map({ 'n' }, '<down>', C('echo "Use j to move"'), '')

-- Sticky keys...
map({ 'c' }, 'W', 'w', 'write')
map({ 'c' }, 'Wq', 'wq', 'write and quit')
map({ 'c' }, 'WQ', 'wq', 'write and quit')
map({ 'c' }, 'WQ', 'wq', 'write and quit')
map({ 'c' }, 'Q', 'q', 'quit')
map({ 'c' }, 'Q!', 'q!', 'quit with unsaved changes')
