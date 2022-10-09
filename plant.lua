-----------------------------------------------------------
----------DILARANG MEMPERJUAL BELIKAN SCRIPT INI-----------
-----------------------------------------------------------
msgto		= "" -- nama yang akan di beri notif
-----------------------------------------------------------
World 		= {""} --World yang akan di plant
id_door		= "" --ID Door World yang akan di plant
-----------------------------------------------------------
World_Seed 	= "" --World Seed
id_door_seed= "" --ID Door Seed
-----------------------------------------------------------
seedid      = 5667 --sesuaikan id seed--
Delay       = 20     --sesuaikan delay--
-----------------------------------------------------------

function Reconnect(world,id)
    if getBot().status == "offline" then
        sleep(2000)
        while getBot().status ~= "online" do
            connect()
            sleep(15000)
        end
        JoinWorld(world,id)
    end
end

function JoinWorld(jWorld,jid)
    sendPacket(3,"action|join_request\nname|"..jWorld)
    sleep(3000)
    sendPacket(3,"action|join_request\nname|"..jWorld.."|"..jid)
    sleep(2500)
end

function AmbilSeed()
    JoinWorld(World_Seed,id_door_seed)
    Reconnect(World_Seed,id_door_seed)
    for _, object in pairs(getObjects()) do
        if object.id == seedid then
            findPath(math.floor(object.x/32),math.floor(object.y/32))
            sleep(500)
            collect(3)
            sleep(1500)
            if findItem(seedid) >= 1 then 
                break 
            end
        end
    end
    sleep(1000)
    if findItem(seedid) == 0 then
        sleep(5000)
        if findItem(seedid) == 0 then
            removeBot(getBot().name)
        end
    end
    JoinWorld(PosWorld,id_door)
    Reconnect(PosWorld,id_door)
end    


function plant()
	::cek::
    for _, tile in pairs(getTiles()) do
        if tile.fg == 0 and getTile(tile.x,tile.y+1).fg ~= 0 and getTile(tile.x,tile.y+1).fg ~= seedid then
            findPath(tile.x,tile.y)
            sleep(Delay)
            repeat
                place(seedid,0,0)
                sleep(Delay)
                if findItem(seedid) == 0 then
                    while findItem(seedid) == 0 do
                        PosX = math.floor(getBot().x/32)
                        PosY = math.floor(getBot().y/32)
                        sleep(500)
                        AmbilSeed()
                        findPath(PosX,PosY)
                        sleep(Delay)
                        repeat
                            place(seedid,0,0)
                            sleep(Delay)
                        until getTile(math.floor(getBot().x/32),math.floor(getBot().y/32)).fg ~= 0
                    end
                    goto cek
                end
            until getTile(math.floor(getBot().x/32),math.floor(getBot().y/32)).fg ~= 0
        end
    end       
end

-----------------------------------------------------------

-----------------------------------------------------------
-----------Dilarang Menghapus Bagian Ini-------------------
say("`2Auto Plant Ready!")
sleep(1000)
-----------------------------------------------------------


collectSet(true,3)

for i, ListWorld in ipairs(World) do
    kondisi = true
    sendPacket(3,"action|join_request\nname|"..ListWorld)
    sleep(3000)
    sendPacket(3,"action|join_request\nname|"..ListWorld.."|"..id_door)
    sleep(1500)
    say("/msg"..msgto.." World "..ListWorld.." Siap Ditanam!")
    sleep(2000)
    PosWorld = getBot().world
    while kondisi do
        plant()
        sleep(200)
        kondisi = false
    end
    say("/msg"..msgto.." World "..ListWorld.." Sudah Ditanam!")
    sleep(1000)
    say("/msg"..msgto.." Pindah Ke World Selanjutnya!")
    sleep(5000)
end
say("/msg"..msgto.." Semua World Telah Ditanam!")
sleep(1000)
removeBot(getBot().name)