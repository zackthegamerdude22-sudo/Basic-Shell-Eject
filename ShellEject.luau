local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local AmmoEject = ReplicatedStorage.GunRemotes:WaitForChild("AmmoEject")


local ShellTemplates = {
	SMG = ReplicatedStorage.BulletShells.SMG:WaitForChild("SMG"),
	["Desert Eagle"] = ReplicatedStorage.BulletShells.DesertEagle:WaitForChild("Shell"),
	["Tommy Gun"] = ReplicatedStorage.BulletShells["Tommy Gun"]:WaitForChild("Shell"),
	["Glock-19"] = ReplicatedStorage.BulletShells["Glock-19"]:WaitForChild("Shell"),
	["AK-47"] = ReplicatedStorage.BulletShells["AK-47"]:WaitForChild("BulletShell"),
}
local function ejectShell(gunTool, shellTemplate, delayTime)
	if delayTime then
		task.wait(delayTime)
	end

	if not gunTool then return end

	local bodyAttach = gunTool:FindFirstChild("BodyAttach")
	if not bodyAttach then return end

	local model = bodyAttach:FindFirstChild("Model")
	if not model then return end

	local eject = model:FindFirstChild("Eject")
	if not eject then return end

	local shell = shellTemplate:Clone()
	shell.Parent = workspace
	shell.CFrame = eject.CFrame * CFrame.new(0, 0, -0.1)

	if gunTool.Name == "Tommy Gun" then
		shell.AssemblyLinearVelocity =
			-eject.CFrame.LookVector * 25 + Vector3.new(0, 15, 0)
		shell.AssemblyAngularVelocity =
			Vector3.new(math.random(), math.random(), math.random()) * 40

	elseif gunTool.Name == "Glock-19" then
		shell.AssemblyLinearVelocity =
			-eject.CFrame.RightVector * 25 + Vector3.new(0, 15, 0)
		shell.AssemblyAngularVelocity =
			Vector3.new(math.random(), math.random(), math.random()) * 40


	elseif gunTool.Name == "AK-47" then
		shell.AssemblyLinearVelocity =
			-eject.CFrame.RightVector * 15 + Vector3.new(0, 20, 0)
		shell.AssemblyAngularVelocity =
			Vector3.new(math.random(), math.random(), math.random()) * 20

	else
		shell.AssemblyLinearVelocity =
			eject.CFrame.RightVector * 15 + Vector3.new(0, 20, 0)
		shell.AssemblyAngularVelocity =
			Vector3.new(math.random(), math.random(), math.random()) * 20
	end

	Debris:AddItem(shell, 5)
end


AmmoEject.OnClientEvent:Connect(function(player, state, gunTool, gunName)
	local localPlayer = Players.LocalPlayer

	if localPlayer:GetAttribute("Ammo") == false then
		return
	end
	
	local shellTemplate = ShellTemplates[gunName]
	if not shellTemplate then return end

	if state == "Shoot" then
		print("GunName received:", gunName)
		ejectShell(player, gunTool, shellTemplate)

	elseif state == "Equip" and gunName == "Desert Eagle" then
		print("equipped")
		task.spawn(function()
			ejectShell(player, gunTool, shellTemplate, 0.2)
		end)

	elseif state == "Equip" and gunName == "Glock-19" then
		print("equipped")
		task.spawn(function()
			ejectShell(player, gunTool, shellTemplate, 0.3)
		end)

	elseif state == "Equip" and gunName == "AK-47" then
		print("equipped")
		task.spawn(function()
			ejectShell(player, gunTool, shellTemplate, 0.3)
		end)

	elseif state == "Equip" and gunName == "Tommy Gun" then
		print("equipped")
		task.spawn(function()
			ejectShell(player, gunTool, shellTemplate, 0.2)
		end)

	elseif state == "Finisher" and gunName == "SMG" then
		ejectShell(player, gunTool, shellTemplate, 0.1)
	elseif state == "Finisher" and gunName == "Desert Eagle" then
		ejectShell(player, gunTool, shellTemplate, 0.1)
	elseif state == "Finisher" and gunName == "Tommy Gun" then
		ejectShell(player, gunTool, shellTemplate, 0.1)
	elseif state == "Finisher" and gunName == "Glock-19" then
		ejectShell(player, gunTool, shellTemplate, 2)
	end
end)
