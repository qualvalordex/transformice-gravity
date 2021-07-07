-- Gravity powered by Transformice
-- Developed by Rufflesdqjo#0095 <qualvalordex@gmail.com>

settings = {
    keys = {70,86},
    maps = {"@7360360", "@7354902", "@6564904", "@7363888", "@7363948", "@7364036", "@7365232", "@7365480", "@7358021", "@7331732", "@7361954", "@6680292", "@7362214", "@7333317", "@7318326", "@7110000", "@7333302", "@6520404", "@7358506", "@7358514", "@7359645", "@2563872", "@606863", "@7357929", "@7357921", "@7356299", "@7355663", "@1854090", "@7355428", "@7355414", "@6331936", "@6330103", "@7354975", "@5452359", "@7354584", "@5615170", "@5628348", "@5628385", "@5632059", "@5632370", "@5636089", "@5638781", "@5638812", "@5688381", "@5688397", "@7356642", "@7357353", "@7356675"}
}

-- Configuration functions

function allowKeyboardKey(player)

    for _,key in pairs (settings.keys) do
        tfm.exec.bindKeyboard(player, key, true);
    end

end

-- Gameplay functions

function boostUp(player)

    tfm.exec.movePlayer(player, 0, 0, true, 0, math.random(-10,-8), true);

end

function boostDown(player)

    tfm.exec.movePlayer(player, 0, 0, true, 0, math.random(8,10), true);

end

-- Misc functions

function randomNumber(from, to)

    return math.random(from, to);

end

-- Event functions

function eventNewGame()

    -- Allow players to use keyboard commands
    for player in pairs (tfm.get.room.playerList) do
        allowKeyboardKey(player);
    end

end

function eventKeyboard(player, key, push, x, y)

    if key == 70 then
        -- What happen if press F?
        boostUp(player);
    end

    if key == 86 then
        -- What happen if press V?
        boostDown(player);
    end

end

-- Go!
tfm.exec.newGame(settings.maps[randomNumber(1, #settings.maps)]);