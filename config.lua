Config = {}

Config.Permissions = {"god", "admin", "mod"} --Player with this group are able to use the menu command

Config.MenuCommand = 'election' --Election Management Menu, Only Admin with Config.Permissions can use it

Config.pedModel = `s_m_y_ammucity_01` --Only works if Config.Target is enabled

Config.Candidates = {
    { name = "Candidate A", party= "A"},
    { name = "Candidate B", party= "B"},
    { name = "Candidate C", party= "C"},
    { name = "Candidate D", party= "D"},
    { name = "Candidate E", party= "E"},
}

Config.VotingBooths = {
    vector4(1704.15, 4924.82, 42.06, 56.58),
    vector4(1695.5, 4931.69, 42.08, 318.94)
}

Config.Debugscript = true

Config.Framework = 'qb' --qb

Config.Notify = 'ox' --qb, ox, okok, custom

Config.DrawText = 'ox' --qb, cd, ox if Config.UseTarget is set to False

Config.UseTarget = true --Set to true if you want to use target

Config.Target = 'ox' --qb, ox


Config.ServerAnnouncement = true -- This is will send a message to Chat for everyone

Config.UpdateVersion = true -- This is disable the script version check on restart