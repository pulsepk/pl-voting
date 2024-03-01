lib.locale()

Config = {}

Config.Permissions = {"god", "admin", "mod"} --Player with this group are able to use the menu command

Config.AdminLicense = { 
    ['license:071516169a85fdc04c9df7ed0355499e626bad95'] = true, --Add Admin license here, Get it from the database in players table
}

Config.MenuCommand = 'election' --Election Management Menu, Only Admin with Config.Permissions can use it

Config.Log = true

Config.Debugpoly = false

Config.Candidates = {
    { name = "John Doe", party= "Independent"},
    { name = "Jane Smith", party= "Democratic Party"},
    { name = "Michael Johnson", party= "Republican Party"},

}

Config.VotingBooths = {
    vector4(1704.15, 4924.82, 42.06, 56.58),
    vector4(1702.29, 4922.7, 42.06, 234.73)
}

Config.Notify = 'ox' --qb, ox, okok,esx, custom

Config.DrawText = 'ox' --qb, cd, ox if Config.UseTarget is set to False

Config.ServerAnnouncement = true -- This is will send a message to Chat for everyone

Config.UpdateVersion = true -- This is disable the script version check on restart