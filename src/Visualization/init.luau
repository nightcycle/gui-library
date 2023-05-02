--!strict
-- Services
-- Packages
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages)
local Maid = require(Packages:WaitForChild("Maid"))
local Synthetic = require(Packages:WaitForChild("Synthetic"))
local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
-- Modules
local Graph = require(script:WaitForChild("Graph"))
local RadarChart = require(script:WaitForChild("RadarChart"))
local ModuleProvider = require(Package:WaitForChild("ModuleProvider"))
local PseudoEnum = ModuleProvider.PseudoEnum
local StyleGuide = ModuleProvider.StyleGuide

-- Types
type Maid = Maid.Maid
type ValueState<T> = ColdFusion.ValueState<T>
type State<T> = ColdFusion.State<T>
type CanBeState<T> = ColdFusion.CanBeState<T>
export type Visualization = {
	__index: Visualization,
	_Maid: Maid,
	_IsAlive: boolean,
	Destroy: (self: Visualization) -> nil,
	GetGraph: (
		self: Visualization,
		data: CanBeState<{ [string]: Vector2 }>,
		backgroundColor: ModuleProvider.GuiColorPalette,
		canvasColor: ModuleProvider.GuiColorPalette,
		color: ModuleProvider.GuiColorPalette,
		xAxisLabel: CanBeState<string>?,
		yAxisLabel: CanBeState<string>?,
		canvasSize: CanBeState<UDim2>?
	) -> Frame,
	GetRadarChart: (self: Visualization, config: RadarChart.GuiParameters) -> Frame,
	new: (maid: Maid) -> Visualization,
}
-- Constants
-- Variables
-- References
-- Class
local Visualization: Visualization = {} :: any
Visualization.__index = Visualization

function Visualization:Destroy()
	if not self._IsAlive then
		return
	end
	self._IsAlive = false
	self._Maid:Destroy()
	local t: any = self
	for k, v in pairs(t) do
		t[k] = nil
	end
	setmetatable(t, nil)
	return nil
end

function Visualization:GetRadarChart(config: RadarChart.GuiParameters)
	return RadarChart(self._Maid, config)
end

function Visualization:GetGraph(
	data: CanBeState<{ [string]: Vector2 }>,
	backgroundColor: ModuleProvider.GuiColorPalette,
	canvasColor: ModuleProvider.GuiColorPalette,
	color: ModuleProvider.GuiColorPalette,
	xAxisLabel: CanBeState<string>?,
	yAxisLabel: CanBeState<string>?,
	canvasSize: CanBeState<UDim2>?
): Frame
	local _fuse = ColdFusion.fuse(self._Maid)
	local _synth = Synthetic(self._Maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local XAxisLabel: State<string> = _import(xAxisLabel, "X-Axis")
	local YAxisLabel: State<string> = _import(yAxisLabel, "Y-Axis")
	local Data: State<{ [string]: Vector2 }> = _import(data, {})
	local CanvasSize: State<UDim2> = (
		if canvasSize
			then _import(canvasSize, UDim2.fromOffset(0, 0))
			else _Computed(function(vSize: Vector2)
				local dim = math.ceil(vSize.Y * 0.5)
				return UDim2.fromOffset(dim, dim)
			end, StyleGuide.ViewportSize)
	) :: any
	local Thickness: State<UDim> = _Computed(function(txtSize: number)
		return UDim.new(0, math.ceil(txtSize / 4))
	end, StyleGuide:GetTextSize(PseudoEnum.GuiTypography.Body1))
	local CanvasColor: State<Color3> = StyleGuide:GetColor(canvasColor or PseudoEnum.GuiColorPalette.Surface2)
	local GridLineColor: State<Color3> = StyleGuide:GetContrastColor(canvasColor or PseudoEnum.GuiColorPalette.Surface2)
	local Color: State<Color3> = StyleGuide:GetContrastColor(
		canvasColor or PseudoEnum.GuiColorPalette.Surface2,
		color or PseudoEnum.GuiColorPalette.Primary2
	)

	local TextColor: State<Color3> = StyleGuide:GetContrastColor(backgroundColor or PseudoEnum.GuiColorPalette.Surface1)

	return Graph(
		self._Maid,
		XAxisLabel,
		YAxisLabel,
		Data,
		CanvasSize,
		Thickness,
		CanvasColor,
		Color,
		GridLineColor,
		TextColor
	)
end

function Visualization.new(maid: Maid)
	local self: Visualization = setmetatable({}, Visualization) :: any
	self._IsAlive = true
	self._Maid = maid

	return self
end

return Visualization
