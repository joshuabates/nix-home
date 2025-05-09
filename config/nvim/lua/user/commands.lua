local utils = require("user.utils")

function CreateStyles()
  local filepath = vim.fn.expand("%:r")
  local filename = vim.fn.expand("%:t:r")
  local cssFile = filepath .. ".scss"

  vim.cmd('normal oimport styles from "./' .. filename .. '.scss";')
  vim.cmd("edit " .. cssFile)
  vim.cmd("vsplit " .. cssFile)
end

vim.cmd("command! CreateStyles lua CreateStyles()")

function CloseQuickFixOrBuffer()
  local window_count = vim.fn.winnr("$")

  -- Check for floating windows first
  for win_num = 1, window_count do
    local win = vim.fn.win_getid(win_num)
    local win_config = vim.api.nvim_win_get_config(win)
    local filetype = vim.fn.getbufvar(vim.fn.winbufnr(win), "&filetype")

    -- Close floating windows unless they are Neo-tree
    if win_config.relative ~= "" and filetype ~= "neo-tree" then
      vim.api.nvim_win_close(win, false)
      return
    end
  end

  -- Handle quickfix and other buffer types
  for win_num = 1, window_count do
    local win = vim.fn.win_getid(win_num)
    local bnum = vim.fn.winbufnr(win_num)
    local buftype = vim.fn.getbufvar(bnum, "&buftype")
    local filetype = vim.fn.getbufvar(bnum, "&filetype")

    if buftype == "quickfix" then
      vim.cmd("cclose")
      return
    elseif buftype == "help" then
      vim.cmd("helpc")
      return
    elseif filetype == "GitBlame" then
      pcall(function()
        vim.api.nvim_win_close(win, false)
      end)
      return
    end
  end

  -- Fallback: close the current window safely if more than one window is open
  if window_count > 1 then
    pcall(function()
      vim.api.nvim_win_close(0, false)
    end)
  else
    utils.warnlog("Cannot close the last window")
  end
end

function EscapePair()
  local closers = { ")", "]", "}", ">", "'", '"', "`", "," }
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local after = line:sub(col + 1, -1)
  local closer_col = #after + 1
  local closer_i = nil
  for i, closer in ipairs(closers) do
    local cur_index, _ = after:find(closer)
    if cur_index and (cur_index < closer_col) then
      closer_col = cur_index
      closer_i = i
    end
  end
  if closer_i then
    vim.api.nvim_win_set_cursor(0, { row, col + closer_col })
  else
    vim.api.nvim_win_set_cursor(0, { row, col + 1 })
  end
end

if not vim.g.vscode then
  vim.api.nvim_set_keymap("i", "<C-l>", "<cmd>lua EscapePair()<CR>", { noremap = true, silent = true })
end

local function copy_migration_timestamp()
  local filename = vim.fn.expand('%:t')
  local timestamp = filename:match("(%d+)_.*%.rb")

  if timestamp then
    vim.fn.system("echo '" .. timestamp .. "' | pbcopy")
    print("Timestamp " .. timestamp .. " copied to clipboard")
  else
    print("No timestamp found in the filename")
  end
end

-- Create a user command to run the function
vim.api.nvim_create_user_command('CopyMigrationTimestamp', copy_migration_timestamp, {})

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuOpen',
  callback = function()
    require("copilot.suggestion").dismiss()
    vim.b.copilot_suggestion_hidden = true
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuClose',
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})
