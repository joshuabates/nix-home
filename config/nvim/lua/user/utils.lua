local M = {}
local fn = vim.fn

M.serializeTable = function (val, name, skipnewlines, depth)
  skipnewlines = skipnewlines or false
  depth = depth or 0

  local tmp = string.rep(" ", depth)

  if name then tmp = tmp .. name .. " = " end

  if type(val) == "table" then
    tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

    for k, v in pairs(val) do
      tmp =  tmp .. M.serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
    end

    tmp = tmp .. string.rep(" ", depth) .. "}"
  elseif type(val) == "number" then
    tmp = tmp .. tostring(val)
  elseif type(val) == "string" then
    tmp = tmp .. string.format("%q", val)
  elseif type(val) == "boolean" then
    tmp = tmp .. (val and "true" or "false")
  else
    tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
  end

  return tmp
end

M.file_exists = function(path)
  local f = io.open(path, "r")
  if f ~= nil then io.close(f) return true else return false end
end

M.starts_with = function(str, start)
  return str:sub(1, #start) == start
end

M.split = function(s, delimiter)
  local result = {}
  for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end

  return result
end

M.handle_job_data = function(data)
  if not data then
    return nil
  end
  if data[#data] == "" then
    table.remove(data, #data)
  end
  if #data < 1 then
    return nil
  end
  return data
end

function serializeMessage(message)
  if (type(message) == "table") then
    return M.serializeTable(message)
  else
    return message
  end
end

M.log = function(message, title)
  require('notify')(serializeMessage(message), "info", { title = title or "Info" })
end

M.warnlog = function(message, title)
  require('notify')(serializeMessage(message), "warn", { title = title or "Warning" })
end

M.errorlog = function(message, title)
  require('notify')(serializeMessage(message), "error", { title = title or "Error" })
end

M.with_cursor_restore = function(fn)
  return function(...)
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local winnr = vim.api.nvim_get_current_win()

    fn(...)

    vim.api.nvim_win_set_cursor(winnr, { line, col })
  end
end

return M
