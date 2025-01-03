vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}
local job_id = 0

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)
  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)
  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end
  -- Define window configuration
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal", -- No borders or extra UI elements
    border = "rounded",
  }
  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end

local function is_terminal_open()
  return vim.api.nvim_win_is_valid(state.floating.win)
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
      job_id = vim.b.terminal_job_id
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

local current_command = ""

local function send_command()
  if job_id > 0 then
    -- Open terminal if it's not already open
    if not is_terminal_open() then
      toggle_terminal()
    end
    vim.fn.chansend(job_id, { current_command .. "\r\n" })
  end
end

vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.keymap.set({ "n", "t" }, "<space>tt", toggle_terminal)
vim.keymap.set({ "n", "t" }, "<space>tr", function()
  if current_command == "" then
    toggle_terminal()
    current_command = vim.fn.input("Command: ")
  end
  send_command()
end)
vim.keymap.set({ "n", "t" }, "<space>te", function()
  current_command = vim.fn.input("New Command: ")
  if current_command ~= "" then
    send_command()
  end
end)
