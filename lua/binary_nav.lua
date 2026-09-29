-- vim: foldmethod=marker
-- lua/binary_nav.lua

local M = {}

local state = {
    active = false,
    low = nil,
    high = nil,
    timer_id = 0,
}

-- Mappings. j and k are temporarily remapped while in binary nav mode. {{{1
local saved_maps = nil

local function install_temp_maps()
    if saved_maps then
        return
    end

    saved_maps = {
        j = vim.fn.maparg("j", "n", false, true),
        k = vim.fn.maparg("k", "n", false, true),
    }

    vim.keymap.set("n", "j", M.step_down, {
        buffer = true,
        silent = true,
    })

    vim.keymap.set("n", "k", M.step_up, {
        buffer = true,
        silent = true,
    })
end

local function restore_map(lhs, map)
    pcall(vim.keymap.del, "n", lhs, { buffer = true })

    if not map or vim.tbl_isempty(map) then
        return
    end

    vim.keymap.set(
        map.mode,
        map.lhs,
        map.rhs,
        {
            expr = map.expr == 1,
            noremap = map.noremap == 1,
            silent = map.silent == 1,
            nowait = map.nowait == 1,
            script = map.script == 1,
            buffer = map.buffer == 1,
        }
    )
end

local function uninstall_temp_maps()
    if not saved_maps then
        return
    end

    restore_map("j", saved_maps.j)
    restore_map("k", saved_maps.k)

    saved_maps = nil
end

-- Highlights. Lines outside current search area are dimmed. {{{1
local ns = vim.api.nvim_create_namespace("binary_nav")

local function clear_highlights()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end

local function update_highlights()
    local buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

    pcall(function()
        vim.api.nvim_buf_set_extmark(buf, ns, vim.fn.line("w0") - 1, 0, {
            end_row = state.low,
            hl_group = "Visual",
            hl_eol = true,
        })
    end)

    pcall(function()
        vim.api.nvim_buf_set_extmark(buf, ns, state.high - 1, 0, {
            end_row = vim.fn.line("w$"),
            hl_group = "Visual",
            hl_eol = true,
        })
    end)
end

-- Exit. Leave binary_nave mode. {{{1
local function restart_timeout()
    state.timer_id = state.timer_id + 1
    local current = state.timer_id

    vim.defer_fn(function()
        if current ~= state.timer_id then
            return
        end

        state.active = false
        clear_highlights()
        uninstall_temp_maps()
    end, vim.o.timeoutlen)
end

-- Movement. {{{1
local function move_to_midpoint()
    local target = math.floor((state.low + state.high) / 2)
    vim.api.nvim_win_set_cursor(0, { target, 0 })

    update_highlights()
    restart_timeout()
end

function M.start_down(mode)
    install_temp_maps()

    state.active = true
    state.low = vim.api.nvim_win_get_cursor(0)[1]
    state.high = vim.fn.line(mode == 'file' and '$' or 'w$') + 1

    move_to_midpoint()
end

function M.start_up(mode)
    install_temp_maps()

    state.active = true
    state.low = mode == 'file' and 1 or (vim.fn.line('w0') - 1)
    state.high = vim.api.nvim_win_get_cursor(0)[1]

    move_to_midpoint()
end

function M.step_down()
    state.low = vim.api.nvim_win_get_cursor(0)[1]

    if state.high - state.low > 1 then
        move_to_midpoint()
    end

end

function M.step_up()
    state.high = vim.api.nvim_win_get_cursor(0)[1]

    if state.high - state.low > 1 then
        move_to_midpoint()
    end
end

-- Setup {{{1
function M.setup()
    vim.keymap.set("n", "<leader>j", function() M.start_down('window') end)
    vim.keymap.set("n", "<leader>k", function() M.start_up('window') end)
    vim.keymap.set("n", "<leader>J", function() M.start_down('file') end)
    vim.keymap.set("n", "<leader>K", function() M.start_up('file') end)
end

return M
