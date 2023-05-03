--!strict
-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages)
local ServiceProxy = require(Packages:WaitForChild("ServiceProxy"))
local PseudoEnum = require(Package:WaitForChild("PseudoEnum"))
local StyleGuide = require(Package:WaitForChild("StyleGuide"))

export type StyleGuide = StyleGuide.StyleGuide
export type PseudoEnums = typeof(PseudoEnum)
export type ContrastStandardType = StyleGuide.ContrastStandardType
export type GuiAlignmentType = StyleGuide.GuiAlignmentType
export type GuiCategoryType = StyleGuide.GuiCategoryType
export type GuiColorPalette = StyleGuide.GuiColorPalette
export type GuiDensityModifier = StyleGuide.GuiDensityModifier
export type GuiThemeType = StyleGuide.GuiThemeType
export type GuiTypography = StyleGuide.GuiTypography

local Util = {
	Override = {
		StyleGuide = nil :: StyleGuide?,
		PseudoEnum = nil :: PseudoEnums?,
	},
}

local PackageFolder = ReplicatedStorage:FindFirstChild("Packages")
if PackageFolder then
	if PackageFolder:FindFirstChild("StyleGuide") then
		Util.Override.StyleGuide = require(PackageFolder:FindFirstChild("StyleGuide")) :: any
	end
	if PackageFolder:FindFirstChild("PseudoEnum") then
		Util.Override.PseudoEnum = require(PackageFolder:FindFirstChild("PseudoEnum")) :: any
	end
end

Util.StyleGuide = ServiceProxy(function()
	return (Util.Override.StyleGuide or StyleGuide) :: StyleGuide
end)
Util.PseudoEnum = ServiceProxy(function()
	return (Util.Override.PseudoEnum or PseudoEnum) :: PseudoEnums
end)

return Util