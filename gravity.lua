-- Gravity powered by Transformice
-- Developed by Rufflesdqjo#0095 <qualvalordex@gmail.com>

settings = {
    keys = {70,86}
}

function allowKeyboardKey(player)

    for _,key in pairs (settings.keys) do
        tfm.exec.bindKeyboard(player, key, true);
    end

end

function boostUp(player)

    tfm.exec.movePlayer(player, 0, 0, true, 0, math.random(-10,-8), true);

end

function boostDown(player)

    tfm.exec.movePlayer(player, 0, 0, true, 0, math.random(8,10), true);

end

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

tfm.exec.newGame("@7360360");