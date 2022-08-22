require("plugs.base")

M = {
    packer_do = function(packer_cmd)
        packer_cmd = packer_cmd or "PackerSync"

        vim.api.nvim_create_autocmd('User', {
            pattern = 'PackerComplete',
            callback = function() vim.g._packcomp = 1 end
        })
        vim.g._packcomp = 0
        vim.cmd(packer_cmd)
        vim.wait(5000, function() return vim.g._packcomp == 1 end)
    end
}

return M
