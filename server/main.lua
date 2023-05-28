local flags = {}

local function isNotBlacklisted(job)
    local forbiddenWords = {"police", "ambulance", "mechanic"}
    for _, word in ipairs(forbiddenWords) do
        if string.find(job, word) then
            DropPlayer(source, '[ts-jobcenter] blacklisted job')
            return false
        end
    end
    return true
end

local function isValid(location, job)
    if isNotBlacklisted(job) then
        for k, v in pairs(Config.Jobs[location]) do
            if v.name == job then
                if ESX.DoesJobExist(job, 0) then
                    return true
                end
            end
        end
        print('[DEBUG] Baan bestaat niet.')
        return false
    end
    return false
end

local function isInRange(location)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    for _,loc in pairs(Config.Locations[location]) do
        local distance = #(coords - loc)
        if distance <= 10 then
            return true
        else
            TriggerClientEvent('ox_lib:notify', source, {title = Config.Locales[Config.Locale]['error'], description = Config.Locales[Config.Locale]['exploit']:format(data.label), type = 'error'})
            Wait(5000)
            DropPlayer(source, '[ts-jobcenter] trigger protection')
        end
        return false
    end
end

local function addFlag(value, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    local reason = 'n.v.t.'
    if flags[source] then
        flags[source] = flags[source] + value
    else
        flags[source] = value
    end

    if flags[source] then
        if flags[source] >= 3 then
            DropPlayer(source, '[ts-jobcenter] flagsystem')
        end
    end
    print('[DEBUG] Player: '..GetPlayerName(source)..' ('..source..') has been flagged. Total amount of flags: '..flags[source]..'')
end

RegisterNetEvent('ts-jobcenter:menu', function(location)

    local elements = {}
    for k, v in pairs(Config.Jobs[location]) do
        local element = {
            title = v.label,
            description = '' .. v.description .. ' | €' .. v.salary .. '',
            serverEvent = 'ts-jobcenter:server:hirePlayer',
            args = { location = location, job = v.name, grade = v.grade, label = v.label }
        }

        if v.icon then
            element.icon = v.icon
        end
        elements[#elements + 1] = element
    end
            
    if isInRange(location) then
        TriggerClientEvent('ts-jobcenter:showSelection', source, {
            elements = elements,
            location = location
        })
    end
end)

RegisterNetEvent('ts-jobcenter:server:hirePlayer', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    for k,v in pairs(Config.Locations[data.location]) do
        local distance = #(coords - v)
        if distance <= 10 then
            if isValid(data.location, data.job) then
                TriggerClientEvent('ox_lib:notify', source, {title = Config.Locales[Config.Locale]['success'], description = Config.Locales[Config.Locale]['hired']:format(data.label), type = 'success'})
                xPlayer.setJob(data.job, data.grade)
            else
                TriggerClientEvent('ox_lib:notify', source, {title = Config.Locales[Config.Locale]['error'], description = Config.Locales[Config.Locale]['invalid_job'], type = 'error' })
                return addFlag(1, data.job)
            end
        else
            TriggerClientEvent('ox_lib:notify', source, {title = Config.Locales[Config.Locale]['error'], description = Config.Locales[Config.Locale]['exploit']:format(data.label), type = 'error'})
            return addFlag(1)
        end
    end
end)
