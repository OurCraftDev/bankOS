json = require "json"

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

title("Administrator Unlock")
write("Type password to unlock adminstrative functions")
term.setCursorPos(1,5)
local adminPassword = read("*")
local hashed_adminPassword = http.get("https://api.hashify.net/hash/sha256/hex?value="..adminPassword)
hashed_adminPassword = hashed_adminPassword.readAll()
hashed_adminPassword = json.decode(hashed_adminPassword).Digest
local file = fs.open("adminPassword.txt","r")
local stored_adminPassword = file.readAll()
file.close()
if hashed_adminPassword == stored_adminPassword then
    term.setCursorPos(1,5)
    term.clearLine()
    term.write("Access Granted")
    sleep(1)
    title("Admin Access")
else
    term.setCursorPos(1,5)
    term.clearLine()
    term.write("Access Denied")
    sleep(1)
    shell.run("startup")
end