require("plugs.base")
packer = require('packer')

function wait_for_packer()
  _packcomp = 0

  vim.api.nvim_create_autocmd('User', {
    pattern = 'PackerComplete',
    callback = function() _packcomp = 1 end
  })

  vim.wait(5000, function() return _packcomp == 1 end)
end

M = {
  install = function()
    packer.install()
    wait_for_packer()
  end,
  sync = function()
    packer.sync()
    wait_for_packer()
  end,
  clean = function()
    packer.clean()
    wait_for_packer()
  end
}

return M
