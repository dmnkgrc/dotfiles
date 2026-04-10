local M = {}

local function normalize_list(t)
	local normalized = {}
	for _, v in pairs(t) do
		if v ~= nil then
			table.insert(normalized, v)
		end
	end
	return normalized
end

function M.setup()
	local harpoon = require("harpoon")
	harpoon:setup({
		menu = {
			width = vim.api.nvim_win_get_width(0) - 4,
		},
		settings = {
			save_on_toggle = true,
		},
	})

	vim.keymap.set("n", "<leader>H", function()
		harpoon:list():add()
	end, { desc = "Harpoon File" })

	vim.keymap.set("n", "<leader>h", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end, { desc = "Harpoon Quick Menu" })

	vim.keymap.set("n", "<leader>fh", function()
		require("snacks").picker({
			finder = function()
				local h = require("harpoon")
				local file_paths = {}
				for _, item in ipairs(h:list().items) do
					table.insert(file_paths, {
						text = item.value,
						file = item.value,
					})
				end
				return file_paths
			end,
			win = {
				input = {
					keys = {
						["dd"] = { "harpoon_delete", mode = { "n", "x" } },
					},
				},
				list = {
					keys = {
						["dd"] = { "harpoon_delete", mode = { "n", "x" } },
					},
				},
			},
			actions = {
				harpoon_delete = function(picker, item)
					local h = require("harpoon")
					local to_remove = item or picker:selected()
					h:list():remove({ value = to_remove.text })
					h:list().items = normalize_list(h:list().items)
					picker:find({ refresh = true })
				end,
			},
		})
	end, { desc = "Find harpoon" })

	for i = 1, 5 do
		vim.keymap.set("n", "<leader>" .. i, function()
			harpoon:list():select(i)
		end, { desc = "Harpoon to File " .. i })
	end
end

return M
