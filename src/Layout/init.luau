--!strict
-- Services
-- Packages
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages)
local Maid = require(Packages:WaitForChild("Maid"))
local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
local Synthetic = require(Packages:WaitForChild("Synthetic"))

-- Modules
local ModuleProvider = require(Package:WaitForChild("ModuleProvider"))
local PseudoEnum = ModuleProvider.PseudoEnum
local DataTable = require(script:WaitForChild("DataTable"))
local StyleGuide = ModuleProvider.StyleGuide

-- Types
type Maid = Maid.Maid
type ValueState<T> = ColdFusion.ValueState<T>
type State<T> = ColdFusion.State<T>
type CanBeState<T> = ColdFusion.CanBeState<T>
export type Layout = {
	__index: Layout,
	_Maid: Maid,
	_IsAlive: boolean,
	Destroy: (self: Layout) -> nil,
	GetDataTable: (
		self: Layout,
		maid: Maid,
		Data: State<{ [number]: { [string]: any } }>,
		columnInputs: { [number]: DataTable.ColumnInput },
		headerTypography: ModuleProvider.GuiTypography?,
		rowTypography: ModuleProvider.GuiTypography?,
		guiDensity: ModuleProvider.GuiDensityModifier?,
		backgroundColorPalette: ModuleProvider.GuiColorPalette?,
		canvasColorPalette: ModuleProvider.GuiColorPalette?,
		rowColorPalette: ModuleProvider.GuiColorPalette?,
		automaticSize: Enum.AutomaticSize?,
		layoutOrder: number?,
		size: CanBeState<UDim2>?
	) -> ScrollingFrame,
	GetUIPadding: (
		self: Layout,
		guiDensityModifier: ModuleProvider.GuiDensityModifier,
		consistentEdges: boolean?
	) -> UIPadding,
	GetVerticalList: (
		self: Layout,
		alignment: ModuleProvider.GuiAlignmentType?,
		density: ModuleProvider.GuiDensityModifier?
	) -> UIListLayout,
	GetHorizontalList: (
		self: Layout,
		alignment: ModuleProvider.GuiAlignmentType?,
		density: ModuleProvider.GuiDensityModifier?
	) -> UIListLayout,
	GetContainer: (
		self: Layout,
		children: { [any]: Instance },
		density: ModuleProvider.GuiDensityModifier?,
		layoutOrder: number?,
		name: CanBeState<string>?,
		palette: ModuleProvider.GuiColorPalette?
	) -> Frame,
	new: (maid: Maid) -> Layout,
}
-- Constants
-- Variables
-- References
-- Private functions

function getHorizontalAndVerticalAlignment(
	alignment: ModuleProvider.GuiAlignmentType?
): (Enum.HorizontalAlignment, Enum.VerticalAlignment)
	if alignment == PseudoEnum.GuiAlignmentType.Center then
		return Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center
	elseif alignment == PseudoEnum.GuiAlignmentType.Left then
		return Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center
	elseif alignment == PseudoEnum.GuiAlignmentType.Right then
		return Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center
	elseif alignment == PseudoEnum.GuiAlignmentType.Top then
		return Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top
	elseif alignment == PseudoEnum.GuiAlignmentType.Bottom then
		return Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Bottom
	elseif alignment == PseudoEnum.GuiAlignmentType.TopLeft then
		return Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Top
	elseif alignment == PseudoEnum.GuiAlignmentType.TopRight then
		return Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Top
	elseif alignment == PseudoEnum.GuiAlignmentType.BottomLeft then
		return Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Bottom
	elseif alignment == PseudoEnum.GuiAlignmentType.BottomRight then
		return Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom
	else
		return Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center
	end
end

function getList(
	const: (any) -> UIListLayout,
	fillDirection: Enum.FillDirection,
	alignment: ModuleProvider.GuiAlignmentType?,
	density: ModuleProvider.GuiDensityModifier?
): UIListLayout
	local horizontal, vertical = getHorizontalAndVerticalAlignment(alignment)

	return const({
		Padding = if density then StyleGuide:GetPadding(density) else UDim.new(0, 0),
		FillDirection = fillDirection,
		HorizontalAlignment = horizontal,
		VerticalAlignment = vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
end

-- Class
local Layout: Layout = {} :: any
Layout.__index = Layout

function Layout:Destroy()
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

function Layout:GetUIPadding(guiDensityModifier: ModuleProvider.GuiDensityModifier, consistentEdges: boolean?): UIPadding
	local _fuse = ColdFusion.fuse(self._Maid)
	local _synth = Synthetic(self._Maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local Padding = StyleGuide:GetPadding(guiDensityModifier)
	local SidePadding = if consistentEdges
		then Padding
		else _Computed(function(pad: UDim)
			return UDim.new(pad.Scale * 0.5, math.ceil(pad.Offset * 0.5))
		end, Padding)

	return _new("UIPadding")({
		PaddingTop = Padding,
		PaddingBottom = Padding,
		PaddingLeft = SidePadding,
		PaddingRight = SidePadding,
	}) :: any
end

function Layout:GetDataTable(
	maid: Maid,
	Data: State<{ [number]: { [string]: any } }>,
	columnInputs: { [number]: DataTable.ColumnInput },
	headerTypography: ModuleProvider.GuiTypography?,
	rowTypography: ModuleProvider.GuiTypography?,
	guiDensity: ModuleProvider.GuiDensityModifier?,
	backgroundColorPalette: ModuleProvider.GuiColorPalette?,
	canvasColorPalette: ModuleProvider.GuiColorPalette?,
	rowColorPalette: ModuleProvider.GuiColorPalette?,
	automaticSize: Enum.AutomaticSize?,
	layoutOrder: number?,
	size: CanBeState<UDim2>?
): ScrollingFrame
	return DataTable(
		maid,
		Data,
		columnInputs,
		headerTypography,
		rowTypography,
		guiDensity,
		backgroundColorPalette,
		canvasColorPalette,
		rowColorPalette,
		automaticSize,
		layoutOrder,
		size
	)
end

function Layout:GetVerticalList(
	alignment: ModuleProvider.GuiAlignmentType?,
	density: ModuleProvider.GuiDensityModifier?
): UIListLayout
	local _fuse = ColdFusion.fuse(self._Maid)
	local _synth = Synthetic(self._Maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	return getList(_new("UIListLayout") :: any, Enum.FillDirection.Vertical, alignment, density)
end

function Layout:GetHorizontalList(
	alignment: ModuleProvider.GuiAlignmentType?,
	density: ModuleProvider.GuiDensityModifier?
): UIListLayout
	local _fuse = ColdFusion.fuse(self._Maid)
	local _synth = Synthetic(self._Maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	return getList(_new("UIListLayout") :: any, Enum.FillDirection.Horizontal, alignment, density)
end

function Layout:GetContainer(
	children: { [any]: Instance },
	density: ModuleProvider.GuiDensityModifier?,
	layoutOrder: number?,
	name: CanBeState<string>?,
	palette: ModuleProvider.GuiColorPalette?
): Frame
	local _fuse = ColdFusion.fuse(self._Maid)
	local _synth = Synthetic(self._Maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local frame = _new("Frame")({
		Name = name,
		LayoutOrder = layoutOrder,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = if palette == nil then 1 else 0,
		Size = UDim2.fromScale(0, 0),
		BackgroundColor3 = if palette then StyleGuide:GetColor(palette) else nil,
		Children = children,
	}) :: any

	if palette then
		local corner = _new("UICorner")({
			CornerRadius = StyleGuide.CornerRadius,
		})
		corner.Parent = frame
	end

	if density then
		local padding = self:GetUIPadding(density)
		padding.Parent = frame
	end

	return frame
end

function Layout.new(maid: Maid)
	local self: Layout = setmetatable({}, Layout) :: any
	self._IsAlive = true
	self._Maid = maid

	return self
end

return Layout
