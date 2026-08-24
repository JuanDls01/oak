-- Chrome monocromo + sintaxis de tokyonight intacta.
--
-- La idea: todo lo que es interfaz (bordes, gutter, statusline, pestañas,
-- dashboard, pickers) vive en la escala de grises, y el color queda
-- reservado para dos cosas que sí lo necesitan: el código y los
-- diagnósticos. El fondo es negro puro para que coincida con Ghostty.

-- Escala de grises de Geist (el sistema de diseño de Vercel), sobre negro.
local mono = {
  bg     = "#000000", -- fondo, en todas las ventanas
  soft   = "#1a1a1a", -- cursorline / hover
  sel    = "#292929", -- fila seleccionada
  line   = "#2e2e2e", -- bordes y separadores
  gutter = "#454545", -- números de línea, guías de indentación y de árbol
  dim    = "#8f8f8f", -- texto terciario
  muted  = "#a1a1a1", -- texto secundario
  fg     = "#ededed", -- texto activo (Geist nunca usa blanco puro)
}

return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      styles = { sidebars = "dark", floats = "dark" },

      -- Solo fondos y grises. Los colores de sintaxis no se tocan.
      on_colors = function(c)
        c.bg = mono.bg
        c.bg_dark = mono.bg
        c.bg_float = mono.bg
        c.bg_popup = mono.bg
        c.bg_sidebar = mono.bg
        c.bg_statusline = mono.bg
        c.bg_highlight = mono.soft
        c.bg_visual = mono.line
        c.border = mono.line
        c.fg_gutter = mono.gutter
      end,

      on_highlights = function(hl, c)
        -- Ventanas
        hl.Normal = { fg = c.fg, bg = mono.bg }
        hl.NormalNC = { fg = c.fg, bg = mono.bg }
        hl.NormalFloat = { fg = c.fg, bg = mono.bg }
        hl.FloatBorder = { fg = mono.line, bg = mono.bg }
        hl.FloatTitle = { fg = mono.fg, bg = mono.bg }
        hl.WinSeparator = { fg = mono.line, bg = mono.bg }
        hl.SignColumn = { bg = mono.bg }
        hl.CursorLine = { bg = mono.soft }
        hl.ColorColumn = { bg = mono.soft }
        hl.Visual = { bg = mono.sel }
        hl.Folded = { fg = mono.dim, bg = mono.soft }
        hl.NonText = { fg = mono.gutter }
        hl.Whitespace = { fg = mono.gutter }
        hl.EndOfBuffer = { fg = mono.bg }

        -- Gutter
        hl.LineNr = { fg = mono.gutter }
        hl.LineNrAbove = { fg = mono.gutter }
        hl.LineNrBelow = { fg = mono.gutter }
        hl.CursorLineNr = { fg = mono.fg, bold = true }
        hl.FoldColumn = { fg = mono.gutter, bg = mono.bg }

        -- Statusline y pestañas
        hl.StatusLine = { fg = mono.muted, bg = mono.bg }
        hl.StatusLineNC = { fg = mono.dim, bg = mono.bg }
        hl.TabLine = { fg = mono.dim, bg = mono.bg }
        hl.TabLineFill = { bg = mono.bg }
        hl.TabLineSel = { fg = mono.fg, bg = mono.bg }
        hl.WinBar = { fg = mono.dim, bg = mono.bg }
        hl.WinBarNC = { fg = mono.gutter, bg = mono.bg }

        -- Menús
        hl.Pmenu = { fg = mono.muted, bg = mono.bg }
        hl.PmenuSel = { fg = mono.fg, bg = mono.sel }
        hl.PmenuSbar = { bg = mono.soft }
        hl.PmenuThumb = { bg = mono.gutter }
        hl.Directory = { fg = mono.muted }
        hl.Title = { fg = mono.fg, bold = true }

        -- Dashboard: el juan.os en blanco
        hl.SnacksDashboardNormal = { fg = c.fg, bg = mono.bg }
        hl.SnacksDashboardHeader = { fg = mono.fg }
        hl.SnacksDashboardTitle = { fg = mono.fg }
        hl.SnacksDashboardDesc = { fg = mono.muted }
        hl.SnacksDashboardIcon = { fg = mono.dim }
        hl.SnacksDashboardKey = { fg = mono.dim }
        hl.SnacksDashboardFooter = { fg = mono.dim }
        hl.SnacksDashboardSpecial = { fg = mono.muted }
        hl.SnacksDashboardDir = { fg = mono.dim }
        hl.SnacksDashboardFile = { fg = mono.muted }

        -- Picker y explorador
        hl.SnacksPicker = { fg = c.fg, bg = mono.bg }
        hl.SnacksPickerBorder = { fg = mono.line, bg = mono.bg }
        hl.SnacksPickerTitle = { fg = mono.fg, bg = mono.bg }
        hl.SnacksPickerDir = { fg = mono.dim }
        hl.SnacksPickerFile = { fg = mono.muted }
        hl.SnacksPickerDirectory = { fg = mono.muted }
        hl.SnacksPickerBufNr = { fg = mono.gutter }
        hl.SnacksPickerMatch = { fg = mono.fg, bold = true }
        hl.SnacksPickerCursorLine = { bg = mono.sel }

        -- Explorer: bordes, título y prompt en gris (nada de naranja ni cian)
        hl.SnacksPickerInputBorder = { fg = mono.line, bg = mono.bg }
        hl.SnacksPickerInputTitle = { fg = mono.muted, bg = mono.bg }
        hl.SnacksPickerInputSearch = { fg = mono.fg }
        hl.SnacksPickerBoxBorder = { fg = mono.line, bg = mono.bg }
        hl.SnacksPickerBoxTitle = { fg = mono.muted, bg = mono.bg }
        hl.SnacksPickerListBorder = { fg = mono.line, bg = mono.bg }
        hl.SnacksPickerListTitle = { fg = mono.muted, bg = mono.bg }
        hl.SnacksPickerListCursorLine = { bg = mono.sel }
        hl.SnacksPickerPreviewBorder = { fg = mono.line, bg = mono.bg }
        hl.SnacksPickerPreviewTitle = { fg = mono.muted, bg = mono.bg }
        hl.SnacksPickerPrompt = { fg = mono.dim }
        hl.SnacksPickerTotals = { fg = mono.dim }
        hl.SnacksPickerTree = { fg = mono.gutter }
        hl.SnacksPickerSelected = { fg = mono.fg }
        hl.SnacksPickerSpecial = { fg = mono.muted }
        hl.SnacksPickerLabel = { fg = mono.dim }
        hl.SnacksPickerToggle = { fg = mono.dim, bg = mono.soft }
        hl.SnacksPickerSpinner = { fg = mono.dim }
        hl.SnacksPickerIdx = { fg = mono.gutter }

        -- Iconos de archivo y carpeta: mini.icons colorea por tipo, así que
        -- toda su paleta se aplana a un único gris.
        for _, name in ipairs({
          "Azure",
          "Blue",
          "Cyan",
          "Green",
          "Grey",
          "Orange",
          "Purple",
          "Red",
          "Yellow",
        }) do
          hl["MiniIcons" .. name] = { fg = mono.muted }
        end

        -- Indentación
        hl.SnacksIndent = { fg = "#1f1f1f" }
        hl.SnacksIndentScope = { fg = "#333333" }
      end,
    },
  },

  { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight-night" } },
}
