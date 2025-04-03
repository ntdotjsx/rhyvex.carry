RegisterCommand('openmenu', function()
    print("HELLO WORLD")
    OpenESXMenu()
end, false)

RegisterKeyMapping('openmenu', 'Open ESX Menu', 'keyboard', 'F9')

function OpenESXMenu()
    local elements = {
        {label = 'Option 1', value = 'option1'},
        {label = 'Option 2', value = 'option2'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'action_menu', {
        title = 'ESX Menu',
        align = 'top-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'option1' then
            print("You selected Option 1")
        elseif data.current.value == 'option2' then
            print("You selected Option 2")
        end
    end, function(data, menu)
        menu.close()
    end)
end
