lib.locale()

Config = {}

Config.WaterMark = true

Config.Permissions = {"god", "admin", "mod"} --Player with this group are able to use the menu command

Config.AdminLicense = { 
    ['license:071516169a85fdc04c9df7ed0355499e626bad95'] = true, --Only For QBCore | Add Admin license here, Get it from the database in players table
}

Config.MenuCommand = 'election' --Election Management Menu, Only Admin with Config.Permissions can use it

Config.Log = true -- If you want to disable Discord Logs | Add your webhook in the serveropen.lua 

Config.Debugpoly = false --If you to see the Voting Booth Radius

Config.Candidates = {
    { name = "John Doe", party= "Independent Party"},
    { name = "Jane Smith", party= "Democratic Party"},
    { name = "Michael Johnson", party= "Republican Party"},

}

Config.VotingBooths = {
    vector3(-541.22, -182.26, 38.23),  --Configured for Gabz Townhall | get it from here https://fivem.gabzv.com/
    vector3(-542.09, -180.64, 38.23),   --Configured for Gabz Townhall | get it from here https://fivem.gabzv.com/
    vector3(-542.84, -179.32, 38.23),   --Configured for Gabz Townhall | get it from here https://fivem.gabzv.com/
    vector3(-534.77, -174.59, 38.23),   --Configured for Gabz Townhall | get it from here https://fivem.gabzv.com/
    vector3(-533.94, -176.22, 38.23),   --Configured for Gabz Townhall | get it from here https://fivem.gabzv.com/
    vector3(-533.15, -177.58, 38.23)    --Configured for Gabz Townhall | get it from here https://fivem.gabzv.com/
}

Config.Notify = 'ox' --qb, ox, okok,esx, custom

Config.DrawText = 'ox' --qb, cd, ox

Config.ServerAnnouncement = true -- This is will send a message to Chat for everyone

Config.UpdateVersion = true -- This is disable the script version check on restart
