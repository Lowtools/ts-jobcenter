local function createBlip(coords, sprite, color, text, scale)
    local x,y,z = table.unpack(coords)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.6)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

CreateThread(function ()
    for k,v in pairs(Config.Locations) do
        createBlip(v.coords, 457, 57, ''..Config.Locales[Config.Locale]['jobcenter']..': '..k..'', 0.6)
    end
end)

CreateThread(function ()
    local sleep = 1000
    local isDrawing = false

    while not ESX.PlayerLoaded do
        Wait(0) 
    end

    while ESX.PlayerLoaded do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for k,v in pairs(Config.Locations) do 
            local playerDist = #(playerCoords - v.coords)

            if playerDist <= 8 then
                sleep = 0
                DrawMarker(2, v.coords.x, v.coords.y, v.coords.z - 0.2, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.3, 0.2, 0.15, 24, 100, 171, 155, false, false, 2, true, nil, nil, false)
            end

            if playerDist <= 1 then
                lib.showTextUI('[E] '..Config.Locales[Config.Locale]['textui']..'', {icon = 'suitcase'})
                isDrawing = true

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent('ts-jobcenter:menu', k)
                end
            else
                isDrawing = false
            end
        end

        if not isDrawing then
            lib.hideTextUI()
        end

        Wait(sleep)
    end   
end)

RegisterNetEvent('ts-jobcenter:showSelection', function(data)
    local registeredContext = {
        title = ''..Config.Locales[Config.Locale]['jobcenter']..' '..data.location..'',
        id = 'jobcenter:selection',
        options = data.elements
    }

    lib.registerContext(registeredContext)
    lib.showContext(registeredContext.id)
end)
