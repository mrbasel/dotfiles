local function is_git_repo()
    local cwd = vim.loop.cwd()
    local result = vim.fn.systemlist('cd ' .. cwd .. ' && git rev-parse --is-inside-work-tree 2> /dev/null')
    return result and result[1] == 'true'
end

local utils = {
    is_git_repo = is_git_repo
}

return utils
