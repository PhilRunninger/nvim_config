local uv = vim.loop

local function list_files(folder)
  local files = {}
  local handle = uv.fs_scandir(folder)
  if not handle then return files end
  while true do
    local name, _ = uv.fs_scandir_next(handle)
    if not name then break end
    table.insert(files, name)
  end
  return files
end

local function file_exists(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == "file"
end

local function PurgeFiles(folder, regex)
  folder = vim.fn.expand(folder)
  local files = list_files(folder)
  local to_delete = {}

  for _, fname in ipairs(files) do
    local orig, _ = fname:match(regex)
    if orig then
      local orig_path = folder .. orig
      if not file_exists(orig_path) then
        table.insert(to_delete, fname)
      end
    end
  end

  if #to_delete > 0 then
    vim.notify("Deleting " .. #to_delete .. " file(s) in " .. folder .. "...")
    for _, fname in ipairs(to_delete) do
      vim.notify("  " .. fname)
      os.remove(folder .. fname)
    end
  else
    vim.notify("Nothing to delete in " .. folder .. ".")
  end
end

function Purge()
  PurgeFiles(vim.o.directory, "^(.*)(%.sw[a-p])$")
  PurgeFiles(vim.o.undodir, "^(.*)$")
end

return {
  Purge = Purge,
}
