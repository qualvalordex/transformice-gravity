-- Gravity powered by Transformice
-- Developed by Rufflesdqjo#0095 <qualvalordex@gmail.com>

settings = {
    keys = {70,86},
    maps = {"@7360360", "@7354902", "@6564904", "@7363888", "@7363948", "@7364036", "@7365232", "@7365480", "@7358021", "@7331732", "@7361954", "@6680292", "@7362214", "@7333317", "@7318326", "@7110000", "@7333302", "@6520404", "@7358506", "@7358514", "@7359645", "@2563872", "@606863", "@7357929", "@7357921", "@7356299", "@7355663", "@1854090", "@7355428", "@7355414", "@6331936", "@6330103", "@7354975", "@5452359", "@7354584", "@5615170", "@5628348", "@5628385", "@5632059", "@5632370", "@5636089", "@5638781", "@5638812", "@5688381", "@5688397", "@7356642", "@7357353", "@7356675"},
    roundTime = 90,
    maxRounds = 10,
    admin = {
        "Rufflesdqjo#0095"
    }
}

round = {
    playing = {},
    current = 0
}

-- Configuration functions

function allowKeyboardKeys()
    for player in pairs (tfm.get.room.playerList) do
        for _,key in pairs (settings.keys) do
            tfm.exec.bindKeyboard(player, key, true);
        end
    end

end

function transformiceSettings()

    tfm.exec.disableAutoShaman(true);
    tfm.exec.disableAutoScore(true);
    tfm.exec.disableAutoTimeLeft(true);
    tfm.exec.disableAutoNewGame(true);
    tfm.exec.disablePhysicalConsumables(true);

end

function roundSettings()

    tfm.exec.setGameTime(settings.roundTime);

end

-- Management functions

function isAdmin(player)

    for _,playerName in pairs (settings.admin) do
        if playerName == player then
            return true;
        end
    end
    
    return false;

end

function isMap(mapCode)

    if string.find(mapCode, '@') == nil then
        return false;
    end

    return true;

end

-- Gameplay functions

function boostUp(player)

    tfm.exec.movePlayer(player, 0, 0, true, 0, math.random(-10,-8), true);

end

function boostDown(player)

    tfm.exec.movePlayer(player, 0, 0, true, 0, math.random(8,10), true);

end

function fillPlayingTable()

    for player in pairs (tfm.get.room.playerList) do
        table.insert(round.playing, player);
    end

end

function dropPlayer(player)
    
    for index, playerName in ipairs (round.playing) do
        if playerName == player then
            table.remove(round.playing, index);
        end
    end

end

function startNewGame()

    for player in pairs (tfm.get.room.playerList) do
        tfm.exec.setPlayerScore(player, 0);
        round['current'] = 0
        tfm.exec.newGame(settings.maps[randomNumber(1, #settings.maps)]);
    end

end

function roundControl(currentRound)

    if currentRound >= 10 then
        startNewGame();
    end

    round.current = round.current + 1;

    return round.current;

end

function countdownToNewRound()
    
    tfm.exec.setGameTime(5);
    system.newTimer(
        function()
            tfm.exec.newGame(settings.maps[randomNumber(1, #settings.maps)]);
        end,
        5000,
        false
    );

end

-- UI functions

function displayRounds(currentRound)

    ui.setShamanName('Round: ' .. currentRound .. '/' .. settings.maxRounds);

end

function displayBackground()
    
    tfm.exec.addImage("160cca62473.png", "?1", 0, 0);

end

-- Misc functions

function randomNumber(from, to)

    return math.random(from, to);

end

function split(text)

    local splitted = {};

    for token in string.gmatch(text, "[^%s]+") do
        table.insert(splitted, token);
    end

    return splitted;

end

-- Event functions

function eventNewGame()

    -- Apply transformice settings
    transformiceSettings();

    -- Apply round settings
    roundSettings();

    -- Allow players to use keyboard commands
    allowKeyboardKeys();

    -- Insert players to playing table
    fillPlayingTable();

    -- Get current round
    round.current = roundControl(round.current);

    -- Display background image
    displayBackground();

    -- Display rounds at UI
    displayRounds(round.current);

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

function eventPlayerWon(player)

    -- Remove player from playing table
    dropPlayer(player);

    -- Set time to 3 seconds if there is not players playing
    if #round.playing == 0 then
        countdownToNewRound();
    end

end

function eventPlayerDied(player)

    -- Remove player from playing table
    dropPlayer(player);

    -- Set time to 3 seconds if there is not players playing
    if #round.playing == 0 then
        countdownToNewRound();
    end

end

function eventChatCommand(player, message)

    local splittedMessage = split(message);
    local command = splittedMessage[1];

    if command == 'np' and isAdmin(player) then
        map = splittedMessage[2];
        if isMap(map) then
            print(map);
            tfm.exec.newGame(map);
        else
            tfm.exec.chatMessage(
                'Invalid map code. Please verify and try again.',
                player
            )
        end
    end

end

-- Go!
transformiceSettings();
tfm.exec.newGame(settings.maps[randomNumber(1, #settings.maps)]);