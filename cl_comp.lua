local selectedItem = nil
local selectedAmount = nil
local selectedPlayer = nil

RegisterNetEvent("kuban-comp:client:OpenCreateCompMenu")
AddEventHandler("kuban-comp:client:OpenCreateCompMenu", function()
    openCompensationMenu()
end)

function openCompensationMenu()
    if Config.MenuType == "ox" then
        openOxMenu()
    elseif Config.MenuType == "qb" then
        openQbMenu()
    else
        print("Invalid MenuType in Config")
    end
end

function openOxMenu()
    local options = {
        {
            title = "Select Item",
            description = selectedItem and ("Current: " .. selectedItem) or "Not Set",
            icon = "box",
            event = "kuban-comp:client:SelectItem"
        },
        {
            title = "Select Amount",
            description = selectedAmount and ("Current: " .. selectedAmount) or "Not Set",
            icon = "hashtag",
            event = "kuban-comp:client:SelectAmount"
        },
        {
            title = "Create Compensation",
            icon = "plus",
            disabled = (not selectedItem or not selectedAmount),
            event = "kuban-comp:client:ConfirmCompensation"
        }
    }
    
    lib.registerContext({
        id = "comp_main_menu",
        title = "Create Compensation",
        options = options
    })
    lib.showContext("comp_main_menu")
end

function openQbMenu()
    local menu = {
        {
            header = "Create Compensation",
            isMenuHeader = true
        },
        {
            header = "Select Item",
            txt = selectedItem and ("Current: " .. selectedItem) or "Not Set",
            params = {
                event = "kuban-comp:client:SelectItem"
            }
        },
        {
            header = "Select Amount",
            txt = selectedAmount and ("Current: " .. selectedAmount) or "Not Set",
            params = {
                event = "kuban-comp:client:SelectAmount"
            }
        },
        {
            header = "Create Compensation",
            txt = "Confirm Selection",
            params = {
                event = "kuban-comp:client:ConfirmCompensation"
            },
            disabled = (not selectedItem or not selectedAmount)
        }
    }
    exports["qb-menu"]:openMenu(menu)
end

RegisterNetEvent("kuban-comp:client:SelectItem")
AddEventHandler("kuban-comp:client:SelectItem", function()
    local input = lib.inputDialog("Enter Item Name", {
        { type = "input", label = "Item Name", required = true }
    })
    
    if input and input[1] then
        selectedItem = input[1]
        openCompensationMenu()
    end
end)

RegisterNetEvent("kuban-comp:client:SelectAmount")
AddEventHandler("kuban-comp:client:SelectAmount", function()
    local input = lib.inputDialog("Enter Amount", {
        { type = "number", label = "Amount", required = true, min = 1 }
    })
    
    if input and input[1] then
        selectedAmount = input[1]
        openCompensationMenu()
    end
end)

RegisterNetEvent("kuban-comp:client:ConfirmCompensation")
AddEventHandler("kuban-comp:client:ConfirmCompensation", function()
    if selectedItem and selectedAmount then
        TriggerServerEvent("kuban-comp:server:CreateComp", selectedItem, selectedAmount) 
    else
        TriggerEvent("QBCore:Notify", "All fields must be filled!", "error")
    end
end)

RegisterNetEvent("kuban-comp:client:CopyCode")
AddEventHandler("kuban-comp:client:CopyCode", function(code)
    lib.setClipboard(code)
    TriggerEvent("QBCore:Notify", "Compensation code copied to clipboard: " .. code, "success")
end)
