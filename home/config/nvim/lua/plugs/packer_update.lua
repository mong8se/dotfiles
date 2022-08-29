require("plugs.base")
packer = require('packer')

function wait_for_packer(packer_command)
  _packcomp = 0

  vim.api.nvim_create_autocmd('User', {
    pattern = 'PackerComplete',
    callback = function() _packcomp = 1 end
  })

  packer_command()

  vim.wait(5000, function() return _packcomp == 1 end)
end

M = {
  install = function()
    wait_for_packer(packer.install)
  end,
  sync = function()
    wait_for_packer(packer.sync)
  end,
  clean = function()
    wait_for_packer(packer.clean)
  end
}

return M
