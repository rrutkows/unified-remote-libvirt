local server = libs.server

local domains
local selected_domain
local selected_action

local inactive_actions = {
    { type = "item", text = "Start", id = "start" }
}

local active_actions = {
    { type = "item", text = "Shutdown", id = "shutdown" },
    { type = "item", text = "Destroy", id = "destroy" }
}

local function get_actions()
    return selected_domain.active and active_actions or inactive_actions
end

local function run_action()
    assert(os.execute("sudo virsh " .. selected_action.id .. " " .. selected_domain.text))
end

local function confirm_action()
    server.update{
        type = "dialog",
        text = "Are you sure you want to " .. selected_action.id .. " " .. selected_domain.text .. "?",
        children = {
            { type = "button", text = "Yes", ontap = "run_action" },
            { type = "button", text = "No" }
        }
    }
end

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
    add_domains("", { type = "item", icon = "play", active = true })
    add_domains("--inactive", { type = "item", icon = "stop", active = false })
    table.sort(domains, function(d1, d2) return d1.text < d2.text end)
    server.update{ id = "list", children = domains }
end

events.focus = function()
    update()
end

actions.refresh = function()
    update()
end

actions.domain = function(i)
    selected_domain = domains[i + 1]
    server.update{
        type = "dialog",
        title = selected_domain.text,
        children = get_actions(),
        ontap = "action_selected"
    }
end

actions.action_selected = function(i)
    selected_action = get_actions()[i + 1]
    if selected_action.id == "shutdown" then
        confirm_action()
    elseif selected_action.id == "destroy" then
        confirm_action()
    elseif selected_action.id == "start" then
        run_action()
    end
end

actions.run_action = function()
    run_action()
end
