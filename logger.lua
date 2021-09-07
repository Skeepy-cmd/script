script_name('Logger')
script_author('Orlow')
script_description('fast_su')

local ev = require("lib.samp.events")
require "lib.moonloader"
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local imgui = require 'imgui'
local main_color = 0x5A90CE
local main_color_text = "{5A90CE}"
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 1.01
local script_vers_text = "1.01"

local update_url = "https://raw.githubusercontent.com/Skeepy-cmd/script/main/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "https://github.com/Skeepy-cmd/script/blob/main/logger.luac?raw=true"
local script_path = thisScript().path



local a = {
    id = -1,
    nickname = "",
}

function ev.onSendTakeDamage(playerId, damage, weapon, bodypart)
    if playerId ~= 65535 then
        a.bool = true
        a.id = playerId
        a.nickname = sampGetPlayerNickname(playerId)

        sampAddChatMessage("Вы получили урон от " ..a.nickname.. ". Выдать розыск за нападение?", main_color)
		sampAddChatMessage("Для выдачи используйте клавишу P", main_color)
    end
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    
	 sampRegisterChatCommand("update", cmd_update)
	 
	 	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)
	
	downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage("Найдена более новая версия! Версия: " .. updateIni.info.vers_text, -1)
                update_state = true
				end
            os.remove(update_path)
        end
    end)
	
    while true do
		wait(0)
	
         if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Скрипт успешно обновлен!", -1)
                    thisScript():reload()
                end
            end)
            break
        end

	end
end