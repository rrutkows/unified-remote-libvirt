local server = libs.server

local domains

local function update()
    domains = {}
    local domainsHandle = assert(io.popen("sudo virsh list --all --name"))
    for domainName in domainsHandle:lines() do
        table.insert(domains, {
            type = "item",
            text = domainName
        })
    end
    domainsHandle:close()
    server.update{id = "list", children = domains}
end

events.focus = function()
    update()
end

actions.refresh = function()
    update()
end
