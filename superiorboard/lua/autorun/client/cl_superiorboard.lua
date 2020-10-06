    surface.CreateFont("superiorfont", {
    font = "Roboto",
    extended = false,
    size = 20,
    weight = 500,
})

    surface.CreateFont("CategoryNames", {
    font = "Roboto",
    extended = false,
    size = 25,
    weight = 500,
})

------------------------------------------- DO NOT TOUCH OR ELSE BREAK RANK
local function TranslateGroup( x, c )
    if not c then
        if superior_config.Ranks[ x ] then
            return superior_config.Ranks[ x ].name
        else
            return 'User'
        end
    else
        if superior_config.Ranks[ x ] then
            return superior_config.Ranks[ x ].col
        else
            return Color( 255, 255, 255 )
        end
    end
end
-------------------------------------------
local function ToggleScoreboard(toggle)
    if toggle then
        local scrw, scrh = ScrW(), ScrH()
        superiorboard = vgui.Create("DFrame")
        superiorboard:ShowCloseButton(false)
        superiorboard:SetTitle("")
        superiorboard:SetSize(scrw * .8, scrh * .9)
        superiorboard:Center()
        superiorboard:MakePopup()
        superiorboard.Paint = function(self, w, h)
                    draw.RoundedBox(20, 0, 0, w, h, Color(24, 24, 24))
                    draw.RoundedBoxEx(20, 0, 0, w, h / 23, Color(41, 41, 41), true, true, false, false)
                    draw.SimpleText("Name", "CategoryNames", ScrW() * .04, h / 17, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText(superior_config.ServerName, "CategoryNames", ScrW() * .01, h / 90, Color(255, 255, 255))
                    draw.SimpleText(player.GetCount() .. "/" .. superior_config.ServerSlots .. " Players", "CategoryNames", ScrW() * .76, h / 42, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText("Ping", "CategoryNames", ScrW() / 1.34 - surface.GetTextSize("Ping") / 2, scrh * .04, superior_config.TextColor)
                    draw.SimpleText("Money", "CategoryNames", ScrW() / 1.68  - surface.GetTextSize("Money") / 2, scrh * .04, superior_config.TextColor)
                    draw.SimpleText("Job", "CategoryNames", ScrW() / 2.44 - surface.GetTextSize("Job") / 2, scrh * .04, superior_config.TextColor)
                    draw.SimpleText("Rank", "CategoryNames", ScrW() / 3.50 - surface.GetTextSize("superiorgroups") / 2, scrh * .04, superior_config.TextColor)
            
            end

            local superiorscroll = vgui.Create("XeninUI.ScrollPanel", superiorboard)
            superiorscroll:SetPos(0, superiorboard:GetTall() * .08)
            superiorscroll:SetSize(superiorboard:GetWide(), superiorboard:GetTall() * .96)
            local ypos = 0
            for k, v in pairs(player.GetAll()) do
                local superiorplayerPanel = vgui.Create("XeninUI.Panel", superiorscroll)

                superiorplayerPanel:SetPos(0, ypos)
                 superiorplayerPanel:SetSize(superiorboard:GetWide(), superiorboard:GetTall() * .04)

                
----------------------------------------------------------------------------------------------------------------------- Dont touch 
                local name = v:Name()
                local job = v:getDarkRPVar("job")
                local money = DarkRP.formatMoney(v:getDarkRPVar("money"))
                local steamid = v:SteamID()
                local ping = v:Ping()
                local pingcolor = Color(0, 255, 0)
                local superiorgroups = TranslateGroup( LocalPlayer():GetUserGroup() )
                if v:Ping() < 20 then
                pingcolor = Color(0, 255, 0)
            elseif v:Ping() < 60 then
                pingcolor = Color(255, 195, 18)
            elseif v:Ping() < 120 then
                pingcolor = Color(234, 32, 39)
            else
                pingcolor = Color(180, 0, 0)
            end
----------------------------------------------------------------------------------------------------------------------- All Buttons in the scoreboard       
            local superioravatarbutton = superiorplayerPanel:Add("XeninUI.Button")
            superioravatarbutton:Dock(LEFT)
            superioravatarbutton:SetSize(38, 38)
            superioravatarbutton.DoClick = function() v:ShowProfile() end



            local superioravatar = vgui.Create("AvatarImage", superioravatarbutton)
                  superioravatar:SetSize(38, 38)
                  superioravatar:SetMouseInputEnabled(false)
                  superioravatar:SetPlayer(v)

            local superiormuted = vgui.Create("DImageButton", superiorplayerPanel)
                superiormuted:SetImage('icon32/unmuted.png')
                superiormuted:SetPos(1490, 5)
                superiormuted:SetSize(30, 30)
                superiormuted.DoClick = function()
                    if LocalPlayer():IsMuted() then
                        LocalPlayer():SetMuted(false)
                         superiormuted:SetImage('icon32/unmuted.png')
                    else
                        LocalPlayer():SetMuted(true)
                        superiormuted:SetImage('icon32/muted.png')
                    end
                end

-----------------------------------------------------------------------------------------------------------------------,  
            superiorplayerPanel.Paint = function(self, w, h)
                if IsValid(v) then
                    surface.SetDrawColor(45, 45, 45)
                    surface.DrawRect(0, 0, w, h)
                    surface.SetFont("superiorfont")
                    draw.SimpleText(name, "superiorfont", ScrW() / 40, ScrH() * .01, Color(255, 255, 255))
                    draw.SimpleText(job, "superiorfont", w / 1.95 - surface.GetTextSize(job) / 2, h / 4, gmod.GetGamemode():GetTeamColor(LocalPlayer()))
                    draw.SimpleText(money, "superiorfont", w / 1.35 - surface.GetTextSize(money) / 2, h / 4, superior_config.TextColor)
                    draw.SimpleText(ping, "superiorfont", w - 100 - surface.GetTextSize(ping) / 2, h / 4, pingcolor)
                    draw.SimpleText(TranslateGroup( LocalPlayer():GetUserGroup(), false ), "superiorfont", w / 3.07 - surface.GetTextSize(superiorgroups, true) / 2, h / 4, TranslateGroup( LocalPlayer():GetUserGroup(), true ))
                end
            end
            ypos = ypos + superiorplayerPanel:GetTall() * 1.1
        end
    else
        if IsValid(superiorboard) then
                superiorboard:Remove()
            end
        end

    end


hook.Add("ScoreboardShow", "superiorboard", function()
    ToggleScoreboard(true)
    return false
end)
hook.Add("ScoreboardHide", "superiorboard", function()
if IsValid(superiorbutton) then superiorbutton:Remove() end
    ToggleScoreboard(false)
end)
hook.Remove("ScoreboardHide", "FAdmin_scoreboard")
hook.Remove("ScoreboardShow", "FAdmin_scoreboard")

