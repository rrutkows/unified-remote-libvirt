local server = libs.server

local domains

local function add_domains(virsh_argument, defaults)
    local domains_handle = assert(io.popen("sudo virsh list --name " .. virsh_argument))
    for domain_name in domains_handle:lines() do
        if domain_name ~= "" then
            local domain = { text = domain_name }
            for k, v in pairs(defaults) do
                domain[k] = v
            end
            table.insert(domains, domain)
        end
    end
    domains_handle:close()
end

local function update()
    domains = {}
    add_domains("", { type = "item", icon = "on", active = true })
    add_domains("--inactive", { type = "item", icon = "off", active = false })
    table.sort(domains, function(d1, d2) return d1.text < d2.text end)
    server.update{id = "list", children = domains}
end

events.focus = function()
    update()
end

actions.refresh = function()
    update()
end
