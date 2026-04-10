local M = {}

function M.setup()
	local function configure()
		local fff = require("fff")
		fff.setup({
			lazy_sync = true,
		})
	end

	local ok, err = pcall(configure)
	if ok then
		vim.g.fff_available = true
		return true
	end

	local ok_download, download = pcall(require, "fff.download")
	if ok_download then
		local rebuilt, rebuild_err = pcall(download.download_or_build_binary)
		if rebuilt then
			ok, err = pcall(configure)
			if ok then
				vim.g.fff_available = true
				return true
			end
		else
			vim.notify(
				("FFF backend rebuild failed: %s"):format(rebuild_err),
				vim.log.levels.WARN
			)
		end
	end

	vim.g.fff_available = false
	vim.notify(
		("FFF is unavailable. Run :lua require(\"fff.download\").download_or_build_binary() and restart Neovim. (%s)"):format(
			err
		),
		vim.log.levels.WARN
	)
	return false
end

return M
