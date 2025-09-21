-- Add this to the end of your ~/.config/nvim/lua/config/keymaps.lua file

-- Smart Go to Implementation for JavaScript/TypeScript
local M = {}

-- Variable to store the original word before jumping
local original_search_word = nil

function M.goto_implementation()
  local current_line = vim.api.nvim_get_current_line()

  -- Store the word under cursor before jumping
  original_search_word = vim.fn.expand('<cword>')

  -- Extract module and function name
  local module_name, func_name = nil, nil

  local patterns = {
    -- const { funcName } = require('module')
    { pattern = "const%s*{[^}]*([%w_]+)[^}]*}%s*=%s*require%(['\"]([^'\"]+)['\"]%)", func_idx = 1,   mod_idx = 2 },
    -- const funcName = require('module/funcName')
    { pattern = "require%(['\"]([^'\"]+)/([^'\"]+)['\"]%)",                          func_idx = 2,   mod_idx = 1 },
    -- const funcName = require('module').funcName
    { pattern = "require%(['\"]([^'\"]+)['\"]%)%.([%w_]+)",                          func_idx = 2,   mod_idx = 1 },
    -- import { funcName } from 'module'
    { pattern = "import%s*{[^}]*([%w_]+)[^}]*}%s*from%s*['\"]([^'\"]+)['\"]",        func_idx = 1,   mod_idx = 2 },
    -- import funcName from 'module'
    { pattern = "import%s+([%w_]+)%s+from%s+['\"]([^'\"]+)['\"]",                    func_idx = 1,   mod_idx = 2 },
    -- Just require('module')
    { pattern = "require%(['\"]([^'\"]+)['\"]%)",                                    func_idx = nil, mod_idx = 1 },
  }

  for _, p in ipairs(patterns) do
    local matches = { current_line:match(p.pattern) }
    if #matches >= 1 then
      module_name = matches[p.mod_idx]
      if p.func_idx and matches[p.func_idx] then
        func_name = matches[p.func_idx]
      end
      break
    end
  end

  if not module_name then
    print("No module found on this line")
    return
  end

  print("Looking for: " .. (func_name and func_name .. " in " or "") .. module_name)

  -- Find the main module file
  local base_paths = {
    "node_modules/" .. module_name .. ".js",
    "node_modules/" .. module_name .. "/index.js",
    "node_modules/" .. module_name .. "/lib/index.js",
    "node_modules/" .. module_name .. "/dist/index.js",
    "node_modules/" .. module_name .. "/src/index.js",
    "node_modules/" .. module_name .. "/build/index.js",
  }

  local main_file = nil
  for _, path in ipairs(base_paths) do
    if vim.fn.filereadable(path) == 1 then
      main_file = path
      break
    end
  end

  if not main_file then
    print("Main file not found for module: " .. module_name)
    return
  end

  -- If we have a function name, try to follow getters
  if func_name then
    local target_file = M.follow_getter(main_file, func_name)
    if target_file then
      vim.cmd("edit " .. target_file)
      M.search_for_function(func_name)
      return
    end
  end

  -- Fallback: open main file and search for function if specified
  vim.cmd("edit " .. main_file)
  if func_name then
    M.search_for_function(func_name)
  end
end

function M.follow_getter(main_file, func_name)
  local content = {}
  local file = io.open(main_file, "r")
  if not file then return nil end

  for line in file:lines() do
    table.insert(content, line)
  end
  file:close()

  for _, line in ipairs(content) do
    local getter_path = line:match("get%s+" .. func_name .. "%(%s*)%s*{%s*return%s+require%(['\"]([^'\"]+)['\"]%)")
    if getter_path then
      local base_dir = main_file:match("(.+)/[^/]+$")
      local target_file = base_dir .. "/" .. getter_path .. ".js"
      if vim.fn.filereadable(target_file) == 1 then
        return target_file
      end
      break
    end
  end
  return nil
end

function M.search_for_function(func_name)
  local search_patterns = {
    "exports%." .. func_name,
    "module%.exports%." .. func_name,
    func_name .. ":",
    "function " .. func_name,
    func_name .. " = ",
    '"' .. func_name .. '"',
    "'" .. func_name .. "'",
  }

  for _, pattern in ipairs(search_patterns) do
    vim.cmd("silent! /" .. pattern)
    if vim.fn.line('.') > 1 then
      print("Found " .. func_name .. " implementation!")
      return
    end
  end

  print("Function " .. func_name .. " not found, but opened the file")
end

function M.follow_require()
  local current_line = vim.api.nvim_get_current_line()
  local current_file = vim.fn.expand('%:p')

  -- Store the word under cursor before jumping
  original_search_word = vim.fn.expand('<cword>')

  local require_path = current_line:match("require%(['\"]([^'\"]+)['\"]%)")
  if not require_path then
    print("No require found on current line")
    return
  end

  local base_dir = current_file:match("(.+)/[^/]+$")
  local target_file

  if require_path:match("^%.") then
    target_file = base_dir .. "/" .. require_path .. ".js"
  else
    target_file = "node_modules/" .. require_path .. ".js"
    if vim.fn.filereadable(target_file) == 0 then
      target_file = "node_modules/" .. require_path .. "/index.js"
    end
  end

  if vim.fn.filereadable(target_file) == 1 then
    vim.cmd("edit " .. target_file)
    print("Opened: " .. target_file)
  else
    print("File not found: " .. target_file)
  end
end

-- Search for the original word that was under cursor before jumping
function M.search_original_word()
  if not original_search_word or original_search_word == "" then
    print("No original word stored. Use after <leader>gi or <leader>fr")
    return
  end

  print("Searching for original word: " .. original_search_word)
  vim.cmd("/" .. original_search_word)
  vim.cmd("normal! zz")
end

-- Keymaps
vim.keymap.set('n', '<leader>gi', M.goto_implementation, { desc = "Go to implementation" })
vim.keymap.set('n', '<leader>fr', M.follow_require, { desc = "Follow require" })
vim.keymap.set('n', '<leader>fw', M.search_original_word, { desc = "Find original word in current file" })
