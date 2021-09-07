script_name('Logger')
script_author('Orlow')
script_description('fast_su')

local ev = require("lib.samp.events")
require "lib.moonloader"
local main_color = 0x5A90CE
local main_color_text = "{5A90CE}"
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
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
    while not isSampAvailable() do wait(100) end

    while true do
        wait(0)
        if isKeyJustPressed(80) then
            sampSendChat("/su "  .. a.id .. " 4 Вооруженное нападение на ПО", -1)
        end
    end
end