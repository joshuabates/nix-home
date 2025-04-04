local M = {}

M.createDirectoryAwarePicker = function(pickerType, baseOpts)
  baseOpts = baseOpts or {}

  local function launchPicker(opts, preserveSearch)
    opts = opts or {}
    local searchToRestore = preserveSearch or ""
    local pickerOpts = vim.deepcopy(vim.tbl_deep_extend("force", baseOpts, opts))

    pickerOpts.actions = pickerOpts.actions or {}
    pickerOpts.actions.select_directory = function(picker)
      local currentSearch = picker.input:get()

      -- Extract directories from results
      local directories = {}
      local dirSet = {}

      for item in picker:iter() do
        if item.file then
          local dir = vim.fn.fnamemodify(item.file, ":h")
          if not dirSet[dir] and vim.fn.isdirectory(dir) == 1 then
            dirSet[dir] = true
            table.insert(directories, {
              text = dir,
              file = dir,
              dir = true
            })
          end
        end
      end

      table.sort(directories, function(a, b) return a.text < b.text end)

      if #directories == 0 then
        require("snacks").notify("No directories found in current results", "warn")
        return
      end

      picker:close()

      vim.schedule(function()
        require("snacks").picker({
          items = directories,
          title = "Select Directory from Results",
          layout = { preset = "select" },
          focus = "input", -- Force focus on input
          enter = true,    -- Start in insert mode
          confirm = function(picker, item)
            picker:close()
            vim.schedule(function()
              launchPicker({ cwd = item.file }, currentSearch)
            end)
          end
        })
      end)
    end

    pickerOpts.win = pickerOpts.win or {}
    pickerOpts.win.input = pickerOpts.win.input or {}
    pickerOpts.win.input.keys = pickerOpts.win.input.keys or {}
    pickerOpts.win.input.keys['<c-d>'] = { "select_directory", mode = { 'i', 'n' } }
    if searchToRestore and searchToRestore ~= "" then
      pickerOpts.search = searchToRestore
    end

    local Snacks = require("snacks")
    if pickerType == "files" then
      Snacks.picker.smart(pickerOpts)
    elseif pickerType == "grep" then
      Snacks.picker.grep(pickerOpts)
    elseif pickerType == "git_files" then
      Snacks.picker.git_files(pickerOpts)
    end
  end

  return function()
    launchPicker()
  end
end

-- Create our enhanced pickers
M.enhancedPickers = {
  files = M.createDirectoryAwarePicker("files"),
  grep = M.createDirectoryAwarePicker("grep"),
  git_files = M.createDirectoryAwarePicker("git_files"),
}

M.searchDirectory = function()
  local Snacks = require("snacks")
  Snacks.picker({
    finder = "proc",
    cmd = "fd",
    args = { "--type", "d", "--exclude", ".git" },
    title = "Select search directory",
    layout = {
      preset = "select",
    },
    actions = {
      confirm = function(picker, item)
        picker:close()
        vim.schedule(function()
          Snacks.picker.grep({
            cwd = item.file,
          })
        end)
      end,
      files_in_dir = function(picker, item)
        picker:close()
        vim.schedule(function()
          Snacks.picker.files({
            cwd = item.file,
          })
        end)
      end,
    },
    win = {
      input = {
        keys = {
          ['<c-d>'] = { 'files_in_dir', mode = { 'i', 'n' } },
        }
      },
    },
    transform = function(item)
      item.file = item.text
      item.dir = true
    end,
  })
end

return M
