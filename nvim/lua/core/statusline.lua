----------------------------------------------------------
-- Statusline configuration file
-----------------------------------------------------------

-- Plugin: feline.nvim (freddiehaddad fork)
-- URL: https://github.com/freddiehaddad/feline.nvim

--[[
For the configuration see the Usage section:
https://github.com/freddiehaddad/feline.nvim/blob/master/USAGE.md
--]]

local status_ok, feline = pcall(require, 'feline')
if not status_ok then
  return
end

--[[
Set colorscheme (from nvim/lua/core/colors.lua)
See: README #Appearance
https://github.com/brainfucksec/neovim-lua?tab=readme-ov-file#appearance
--]]
local colors = require('core/colors')

--[[
Set colors for vi_mode_colors
See: vi_mode_colors
https://github.com/freddiehaddad/feline.nvim/blob/main/USAGE.md#setup-function

Colors are defined nvim/lua/core/colors.lua (See: Statusline color schemes.)
--]]
local vi_mode_colors = {
  NORMAL = colors.green,
  OP = colors.green,
  INSERT = colors.blue,
  VISUAL = colors.blue,
  LINES = colors.blue,
  BLOCK = colors.blue,
  REPLACE = colors.violet,
  ['V-REPLACE'] = colors.violet,
  ENTER = colors.cyan,
  MORE = colors.cyan,
  SELECT = colors.orange,
  COMMAND = colors.green,
  SHELL = colors.green,
  TERM = colors.green,
  NONE = colors.yellow
}

--[[
Providers (LSP, vi_mode)
See: Default providers
https://github.com/freddiehaddad/feline.nvim/blob/main/USAGE.md#default-providers
--]]
local lsp = require 'feline.providers.lsp'
local vi_mode_utils = require 'feline.providers.vi_mode'

-- LSP diagnostic
local lsp_get_diag = function(str)
  local count = vim.lsp.diagnostic.get_count(0, str)
  return (count > 0) and ' '..count..' ' or ''
end

--[[
Separator style
You can use default presets:
https://github.com/freddiehaddad/feline.nvim/blob/main/USAGE.md#separator-presets
--]]
--local separator = '|'
local separator = '│'


--[[
My components
See: Components
https://github.com/freddiehaddad/feline.nvim/blob/main/USAGE.md#components
--]]
local my_comps = {
  ----------------------------
  -- vi_mode: NORMAL, INSERT..
  ----------------------------
  vi_mode = {
    provider = function()
      local label = ' '..vi_mode_utils.get_vim_mode()..' '
      return label
    end,
    hl = function()
      local set_color = {
        name = vi_mode_utils.get_mode_highlight_name(),
        fg = colors.bg,
        bg = vi_mode_utils.get_mode_color(),
        style = 'bold',
      }
      return set_color
    end,
    left_sep = ' ',
    right_sep = ' ',
  },
  ------------
  -- File info
  ------------
  file_info = {
    provider = {
      name = 'file_info',
      opts = {
        type = 'relative',
        file_modified_icon = '',
      }
    },
    hl = { fg = colors.cyan },
    icon = '',
  },
  ------------
  -- File type
  ------------
  file_type = {
    provider = function()
      local type = vim.bo.filetype:lower()
      local extension = vim.fn.expand '%:e'
      local icon = require('nvim-web-devicons').get_icon(extension)
      if icon == nil then
        icon = ''
      end
      return ' ' .. icon .. ' ' .. type
    end,
    hl = { fg = colors.cyan },
    left_sep = {
      str = ' ' .. separator,
      hl = { fg = colors.fg },
    },
    righ_sep = ' ',
  },
  -------------------
  -- Operating System
  -------------------
  os = {
    provider = function()
      local os = vim.bo.fileformat:lower()
      local icon
      if os == 'unix' then
        icon = '  '
      elseif os == 'mac' then
        icon = '  '
      else
        icon = '  '
      end
      --return icon .. os
      return icon
    end,
    hl = { fg = colors.fg },
    left_sep = {
      str = ' ' .. separator,
      hl = { fg = colors.fg },
    },
  },
  ----------------
  -- File encoding
  ----------------
  file_encoding = {
    provider = { name = 'file_encoding' },
    hl = { fg = colors.fg },
    right_sep = {
      str = ' ' .. separator,
      hl = { fg = colors.fg },
    },
  },
  -----------------------
  -- Cursor position in %
  -----------------------
  line_percentage = {
    provider = { name = 'line_percentage' },
    hl = {
      fg = colors.cyan,
      style = 'bold',
    },
    left_sep = ' ',
    right_sep = ' ',
  },
  -------------------------------
  -- Cursor position: Line:column
  -------------------------------
  position = {
    provider = { name = 'position' },
    hl = {
      fg = colors.fg,
      style = 'bold',
    },
    left_sep = ' ',
    right_sep = ' ',
  },
  ------------
  -- Scrollbar
  ------------
  scroll_bar = {
    provider = { name = 'scroll_bar' },
    hl = { fg = colors.fg },
    left_sep = ' ',
    right_sep = ' ',
  },
  --------------------------
  -- LSP diagnostic messages
  --------------------------
  diagnostic = {
    err = {
      provider = 'diagnostic_errors',
      icon = ' ',
      hl = { fg = colors.red },
      left_sep = '  ',
    },
    warn = {
      provider = 'diagnostic_warnings',
      icon = ' ' ,
      hl = { fg = colors.yellow },
      left_sep = ' ',
    },
    info = {
      provider = 'diagnostic_info',
      icon = ' ',
      hl = { fg = colors.green },
      left_sep = ' ',
    },
    hint = {
      provider = 'diagnostic_hints',
      icon = ' ',
      hl = { fg = colors.cyan },
      left_sep = ' ',
    },
  },
  ------------------
  -- LSP information
  ------------------
  lsp = {
    name = {
      provider = 'lsp_client_names',
      icon = '  ',
      hl = { fg = colors.violet },
      left_sep = '  ',
      right_sep = ' ',
    }
  },
  -----------
  -- git info
  -----------
  git = {
    branch = {
      provider = 'git_branch',
      icon = ' ',
      hl = { fg = colors.violet },
      left_sep = '  ',
    },
    add = {
      provider = 'git_diff_added',
      icon = '  ',
      hl = { fg = colors.green },
      left_sep = ' ',
    },
    change = {
      provider = 'git_diff_changed',
      icon = '  ',
      hl = { fg = colors.orange },
      left_sep = ' ',
    },
    remove = {
      provider = 'git_diff_removed',
      icon = '  ',
      hl = { fg = colors.red },
      left_sep = ' ',
    }
  }
}

-- Get active/inactive components
-- See: https://github.com/freddiehaddad/feline.nvim/blob/main/USAGE.md#components
local components = {
  active = {},
  inactive = {},
}

table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.inactive, {})
table.insert(components.inactive, {})

-- Right section
table.insert(components.active[1], my_comps.vi_mode)
table.insert(components.active[1], my_comps.file_info)
table.insert(components.active[1], my_comps.git.branch)
table.insert(components.active[1], my_comps.git.add)
table.insert(components.active[1], my_comps.git.change)
table.insert(components.active[1], my_comps.git.remove)
table.insert(components.inactive[1], my_comps.file_info)

-- Left Section
table.insert(components.active[2], my_comps.diagnostic.err)
table.insert(components.active[2], my_comps.diagnostic.warn)
table.insert(components.active[2], my_comps.diagnostic.hint)
table.insert(components.active[2], my_comps.diagnostic.info)
table.insert(components.active[2], my_comps.lsp.name)
table.insert(components.active[2], my_comps.file_type)
table.insert(components.active[2], my_comps.os)
table.insert(components.active[2], my_comps.file_encoding)
table.insert(components.active[2], my_comps.line_percentage)
table.insert(components.active[2], my_comps.position)

-- Call feline
feline.setup {
  theme = {
    bg = colors.bg,
    fg = colors.fg,
  },
  components = components,
  vi_mode_colors = vi_mode_colors,
  force_inactive = {
    filetypes = {
      '^NvimTree$',
      '^packer$',
      '^vista$',
      '^help$',
    },
    buftypes = {
      '^terminal$'
    },
    bufnames = {},
  },
}
