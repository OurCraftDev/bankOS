json = require "json"

-- A function for easily creating a title, will prob move to a utility file once this gets bigger
local version = "Alpha"
local function title(title_name)
    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(colors.yellow)
    term.write("BANKOS | "..version)
    term.setCursorPos(1,2)
    term.write(title_name)
    term.setCursorPos(1,4)
    term.setTextColor(colors.white)
end

-- Function for creating the account using the data collected by createAcc()
local function createAccData(uuid,username,password)
    local hashed_password = http.get("https://api.hashify.net/hash/sha256/hex?value="..password)
    hashed_password = hashed_password.readAll()
    hashed_password = json.decode(hashed_password).Digest
    local file = fs.open("accounts/"..uuid..".txt","w")
    local accountData = json.encode({Username = username, Password = hashed_password, Balance = 0})
    file.write(accountData)
    file.close()
    fs.copy("accounts/"..uuid..".txt","disk/core/"..uuid..".txt")
end

-- Function for managing account initialization
local function createAcc()
    title("Create account")
    local data, err = http.get("https://www.uuidgenerator.net/api/version1")
    uuid = data.readAll()
    term.write("Type in a username.")
    term.setCursorPos(1,5)
    local username = read()
    term.setCursorPos(1,6)
    term.write("Type in a password")
    term.setCursorPos(1,7)
    local password = read("*")
    createAccData(uuid,username,password)
end

title("Home Screen")

-- Checks if there is a disk, if not, doesent run code
if disk.isPresent("left") then

    -- wip admin login that allows bypassing the anti termination (anti termination has yet to be added due to this being an dev build)
    --local event, keys = os.pullEvent()
    --if event == "keys" and "keys" == keys.o then
        --shell.run("adminlogin.lua")
    --end

    -- Checks if the floppy already has account data on it
    if fs.exists("disk/core/") then
        print("Account already exists on this drive.")
        sleep(1)
        shell.run("startup.lua")
    else 
        createAcc()
    end 
else
    print("Please insert a floppy Disk.")
    sleep(1)
    shell.run("startup")
end