return {
	'nvim-mini/mini.nvim',
    version = false,
	config = function()
		require('mini.notify').setup()
		vim.notify = require('mini.notify').make_notify()

		require('mini.icons').setup()

		require('mini.ai').setup()

		require('mini.comment').setup()

		require('mini.cursorword').setup()

		-- require('mini.extra').setup()

		require('mini.align').setup({
			mappings = {
				start = 'gl',
				start_with_preview = 'gL'
			}
		})

		require('mini.surround').setup({
			-- Use tpope's mappings to preserve nvim's `s` operator without delays.
			mappings = {
				add = 'ys',
				delete = 'ds',
				replace = 'cs',
				find = '',
				find_left = '',
				highlight = '',
				update_n_lines = ''
			}
		})

		require('mini.diff').setup({
			view = {
				style = 'sign',
				signs = { add = '▌', change = '█', delete = '▐' }
			}
		})

	end
}
