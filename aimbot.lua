local client = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = client:GetMouse()
local players = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local function closestPlayer(fov)
   local target = nil --The player to return
   local closest = fov or math.huge --The farthest a player can be (The fov circle)
   for i,v in ipairs(players:GetPlayers()) do
       if v.Character and client.Character and v ~= client and v.Character:FindFirstChild("Head") then --You can add teamcheck here or make it a variable in the function's parameters
           local _, onscreen = camera:WorldToScreenPoint(v.Character.Head.Position) --Sometimes their position is not even on the screen so you have to make sure
           if onscreen then
               local targetPos = camera:WorldToViewportPoint(v.Character.Head.Position) --Their screen position
               local mousePos = camera:WorldToViewportPoint(mouse.Hit.p) --More acurate position of the mouse than just mouse.X
               local dist = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(targetPos.X, targetPos.Y)).magnitude --Distance from mouse
               if dist < closest then
                   closest = dist
                   target = v
               end
           end
       end
   end
   return target
end
local function aimAt(pos,smooth)
  local targetPos = camera:WorldToScreenPoint(pos)
  local mousePos = camera:WorldToScreenPoint(mouse.Hit.p)
  mousemoverel((targetPos.X-mousePos.X)/smooth,(targetPos.Y-mousePos.Y)/smooth)
end
local isAiming = false
uis.InputBegan:Connect(function(input)
   if input.KeyCode == Enum.KeyCode.Q then isAiming = true end
end)
uis.InputEnded:Connect(function(input)
   if input.KeyCode == Enum.KeyCode.Q then isAiming = false end
end)
rs.RenderStepped:connect(function()
   local t = closestPlayer(800)
   if t and isAiming then
       aimAt(t.Character.Head.Position, 6)
   end
end)
