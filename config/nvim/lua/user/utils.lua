local M = {}

M.serializeTable = function(val, name, skipnewlines, depth)
  skipnewlines = skipnewlines or false
  depth = depth or 0

  local tmp = string.rep(" ", depth)

  if name then tmp = tmp .. name .. " = " end

  if type(val) == "table" then
    tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

    for k, v in pairs(val) do
      tmp = tmp .. M.serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
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
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
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

M.is_gem_in_bundle = function(gem_name)
  local cmd = string.format("bundle show %s 2>/dev/null", gem_name)
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()
  return result ~= ""
end

M.maybe_gem_cmd = function(gem_name, extra_args)
  local gem_cmd_override = {
    ["standard"] = "standardrb",
    -- Add more overrides as needed
  }

  local cmd_name = gem_cmd_override[gem_name] or gem_name
  local cmd

  if M.is_gem_in_bundle(gem_name) then
    cmd = { vim.fn.exepath("bundle"), "exec", cmd_name }
  else
    local system_cmd = vim.fn.exepath(cmd_name)
    if system_cmd ~= "" then
      cmd = { system_cmd }
    else
      cmd = { vim.fn.exepath("ruby"), "-S", cmd_name }
    end
  end

  if extra_args then
    for _, arg in ipairs(extra_args) do
      table.insert(cmd, arg)
    end
  end

  return cmd
end

local package_json_cache = {
  path = nil,
  content = nil,
}

M.is_package_in_yarn = function(package_name)
  local cwd = vim.fn.getcwd()
  local package_json_path = cwd .. "/package.json"
  local parsed
  if package_json_cache.path == package_json_path then
    parsed = package_json_cache.content
  else
    if vim.fn.filereadable(package_json_path) == 0 then
      package_json_cache.path = package_json_path
      package_json_cache.content = nil
      return false
    end

    local package_json_content = vim.fn.readfile(package_json_path)
    local success
    success, parsed = pcall(vim.fn.json_decode, table.concat(package_json_content, "\n"))

    if not success then
      print("Error parsing package.json")
      return false
    end

    package_json_cache.path = package_json_path
    package_json_cache.content = parsed
  end
  if not parsed then
    return false
  end

  return (parsed.dependencies and parsed.dependencies[package_name]) or
      (parsed.devDependencies and parsed.devDependencies[package_name])
end

M.maybe_yarn_cmd = function(package_name, extra_args)
  local package_cmd_override = {
    -- ["some-package"] = "some-command",
  }

  local cmd_name = package_cmd_override[package_name] or package_name
  local cmd

  if M.is_package_in_yarn(package_name) then
    cmd = { vim.fn.exepath("yarn"), "run", cmd_name }
  else
    local system_cmd = vim.fn.exepath(cmd_name)

    if system_cmd ~= "" then
      cmd = { system_cmd }
    else
      cmd = { vim.fn.exepath("npx"), cmd_name }
    end
  end

  if extra_args then
    for _, arg in ipairs(extra_args) do
      table.insert(cmd, arg)
    end
  end

  return cmd
end

return M
