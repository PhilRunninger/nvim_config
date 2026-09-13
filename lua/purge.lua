local function get_files(folder, regex)
    local files = {}
    local handle = vim.uv.fs_scandir(folder)
    if not handle then return files end
    while true do
        local name, _ = vim.uv.fs_scandir_next(handle)
        if not name then break end

        local original = vim.fn.substitute(name, '%%', ':\\', 'e')
        original = vim.fn.substitute(original, '%', '\\', 'ge')
        original = vim.fn.matchstr(original, regex)
        files[name] = original
    end
    return files
end

local function PurgeFiles(folder, regex)
    folder = vim.fn.expand(folder)
    local files = get_files(folder, regex)

    vim.notify("Deleting unneeded file(s) in " .. folder .. "...")
    for fname, original in pairs(files) do
        if vim.fn.filereadable(original) == 0 then
            vim.notify('   ' .. fname)
            vim.fn.delete(folder .. fname)
        end
    end
    vim.notify(" ")
end

vim.api.nvim_create_user_command('Purge', function(args)
    PurgeFiles(vim.o.directory, "^.*\\ze\\.sw[a-p]$")
    PurgeFiles(vim.o.undodir, "^.*$")
    vim.notify('Done.')
end, {nargs=0})
