lib.locale()

Config = {}

Config.WaterMark = true

Config.Permissions = {"god", "admin", "mod"} -- ESX: groups that can use the admin menu

Config.AdminLicense = {
    ['license:'] = true, -- QB/QBox: add license identifiers here
}

Config.MenuCommand = 'election' -- Command to open the admin election panel

-- Logging ----------------------------------------------------------------
Config.Log        = true          -- Set false to disable logs
Config.LogWebhook = ""            -- Discord webhook URL (required when LogType = 'discord')
Config.LogType    = 'discord'     -- 'discord' | 'fivemanage' | 'fivemerr'
-- ------------------------------------------------------------------------

Config.Debugpoly = false -- Show voting booth zone outlines

Config.Candidates = {
    { name = "John Doe",        party = "Independent Party" },
    { name = "Jane Smith",      party = "Democratic Party"  },
    { name = "Michael Johnson", party = "Republican Party"  },
}

Config.VotingBooths = {
    vector3(-541.22, -182.26, 38.23),
    vector3(-542.09, -180.64, 38.23),
    vector3(-542.84, -179.32, 38.23),
    vector3(-534.77, -174.59, 38.23),
    vector3(-533.94, -176.22, 38.23),
    vector3(-533.15, -177.58, 38.23),
}

Config.ServerAnnouncement = true  -- Broadcast a chat message on election start/end
Config.UpdateVersion      = true  -- Enable resource version check on start
