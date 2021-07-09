-- Gravity powered by Transformice
-- Developed by Rufflesdqjo#0095 <qualvalordex@gmail.com>

settings = {
    keys = {70,86,38,87},
    maps = {"@7360360"},
    mapsToAdd = {},
    roundTime = 90,
    maxRounds = 10,
    admin = {
        "Rufflesdqjo#0095",
        "Ork#0015"
    },
    mapFile = 1
}

round = {
    playing = {},
    current = 0,
    topScore = {
        name = '',
        score = 0
    }
}

uiElements = {
    text = {
        en = {
            roundLabel = 'Round: ',
            winner1 = 'Congratulations ',
            winner2 = '! You are the winner!',
            welcomeMessage = '<font color=\'#C53DFF\'>Welcome to Gravity! Type !help to get some informations.</font>',
            help = '<VP>The basic game controls are F to go up and V to go down. Remember you can\'t jump! Submit your suggestions in the oficial thread: https://atelier801.com/topic?f=6&t=859194&p=1</VP>'
        },
        br = {
            roundLabel = 'Rodada: ',
            winner1 = 'Parabéns ',
            winner2 = '! Você é o vencedor!',
            welcomeMessage = '<font color=\'#C53DFF\'>Seja bem-vindo ao Gravity! Digite !help para obter ajuda.</font>',
            help = '<VP>Os comandos básicos do jogo são as teclas F para subir e V para descer. Lembre-se, você não pode pular! Envie suas sugestões no tópico oficial do jogo: https://atelier801.com/topic?f=6&t=859194&p=1<VP>'
        }
    }
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

    system.disableChatCommandDisplay('maps', true);
    system.disableChatCommandDisplay('np', true);
    system.disableChatCommandDisplay('addmap', true);
    system.disableChatCommandDisplay('rmmap', true);
    system.disableChatCommandDisplay('save', true);
    system.disableChatCommandDisplay('help', true);

end

function roundSettings()

    tfm.exec.setGameTime(settings.roundTime);

end

function resetControlVariables()

    first = true;

end

function loadMaps()

    local loadingMaps = system.loadFile(settings.mapFile);
    local reloader;
    reloader = system.newTimer(
        function()
            if not loadingMaps then
                loadingMaps = system.loadFile(settings.mapFile);
            end
        end,
        1000,
        true
    );

end

function fillMapTable(mapData)

    settings.maps = {};
    for _,mapCode in pairs (split(mapData)) do
        if isMap(mapCode) then
            table.insert(settings.maps, mapCode);
        end
    end

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

function isNewMap(mapCode)

    for _,map in pairs (settings.maps) do
        if mapCode == map then
            print('This map just exists in database.');
            return false;
        end
    end
    return true;

end

function addMaps(mapCodes)

    for _,mapCode in pairs (mapCodes) do
        if isMap(mapCode) and isNewMap(mapCode) then
            table.insert(settings.maps, mapCode);
        end
    end

end

function remMaps(mapCodes)

    for _,mapCode in pairs (mapCodes) do
        for index, map in ipairs (settings.maps) do
            if mapCode == map then
                table.remove(settings.maps, index);
            end
        end
    end

end

function translate()

    local community = tfm.get.room.community;
    print(community);
    -- Returns the table containing messages in portuguese
    if community == 'pt' or community == 'br' then
        return uiElements.text['br'];
    end

    return uiElements.text['en'];

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
    end

    round.current = 0;
    round.topScore.name = '';
    round.topScore.score = 0;

    tfm.exec.newGame(settings.maps[randomNumber(1, #settings.maps)]);

end

function roundControl(currentRound)

    if currentRound >= 10 then
        announceWinner();
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

function givePoints(player)
    
    if first == true then
        tfm.exec.setPlayerScore(player, 3, true);
        first = false;
    else
        tfm.exec.setPlayerScore(player, 1, true);
    end

end

function setTopScore()

    for player in pairs (tfm.get.room.playerList) do
        currentPlayerScore = tfm.get.room.playerList[player].score;
        if currentPlayerScore > round.topScore.score then
            round.topScore.name = player;
            round.topScore.score = currentPlayerScore;
        end
    end

    colorTopScore();

end

function colorTopScore()

    tfm.exec.setNameColor(round.topScore.name, 0xFFFF00);

end

function announceWinner()
    
    -- Get translation for winner texts
    local winner1 = translate().winner1;
    local winner2 = translate().winner2;

    tfm.exec.chatMessage(winner1 .. round.topScore.name .. winner2);

end

-- UI functions

function displayRounds(currentRound)

    -- Get translation for round label
    roundLabel = translate().roundLabel;

    ui.setShamanName(roundLabel .. currentRound .. '/' .. settings.maxRounds);

end

function displayBackground()
    
    tfm.exec.addImage("160cca62473.png", "?1", 0, 0);

end

function displayWelcomeMessage(player)

    -- Get translation for welcome message
    local welcomeMessage = translate().welcomeMessage;

    tfm.exec.chatMessage(welcomeMessage, player);

end

function displayHelpMessage(player)

    -- Get translation for help message
    local help = translate().help;

    tfm.exec.chatMessage(help, player);

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

function join(table, separator)

    local joined = '';

    for _,item in pairs (table) do
        joined = joined .. separator .. item;
    end

    return joined;

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

    -- Reset gameplay control variables
    resetControlVariables();

    -- Set top score
    setTopScore();

end

function eventKeyboard(player, key, push, x, y)

    if key == 38 then
        -- What happen if press up arrow?
        tfm.exec.killPlayer(player);
    end
    
    if key == 70 then
        -- What happen if press F?
        boostUp(player);
    end

    if key == 86 then
        -- What happen if press V?
        boostDown(player);
    end

    if key == 87 then
        -- What happen if press W?
        tfm.exec.killPlayer(player);
    end

end

function eventPlayerWon(player)

    -- Give player points
    givePoints(player);

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
            tfm.exec.newGame(map);
        else
            tfm.exec.chatMessage(
                'Invalid map code. Please verify and try again.',
                player
            )
        end
    end

    -- Return all maps added to game
    if command == 'maps' then
        tfm.exec.chatMessage(join(settings.maps, ' '), player);
    end

    -- Add maps
    if command == 'addmap' and isAdmin(player) then
        table.remove(splittedMessage, 1);
        addMaps(splittedMessage);
    end

    -- Remove maps
    if command == 'rmmap' and isAdmin(player) then
        table.remove(splittedMessage, 1);
        remMaps(splittedMessage);
    end

    -- Save map database
    if command == 'save' and isAdmin(player) then
        mapData = join(settings.maps, ' ');
        system.saveFile(mapData, 1);
        print('Database updated.');
    end

    -- Get help
    if command == 'help' then
        displayHelpMessage();
    end

end

function eventFileLoaded(fileId, fileData)

    if fileId == '1' then
        fillMapTable(fileData);
    end

end

-- Go!
transformiceSettings();
loadMaps();
startNewGame();