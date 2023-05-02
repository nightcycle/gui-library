--!strict
-- Services
local HttpService = game:GetService("HttpService")
-- Packages
local GraphModule = script.Parent
assert(GraphModule)
local VisModule = GraphModule.Parent
assert(VisModule)
local Package = VisModule.Parent
assert(Package)
assert(Package)
local Packages = Package.Parent
assert(Packages)
local Maid = require(Packages:WaitForChild("Maid"))
local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
-- Modules
local ModuleProvider = require(Package:WaitForChild("ModuleProvider"))
local StyleGuide = ModuleProvider.StyleGuide
-- Types
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>
type Maid = Maid.Maid
-- Constants
-- Variables
-- References
-- Class
return function(coreGui: Frame)
	local maid = Maid.new()

	task.spawn(function()
		StyleGuide.init(maid)

		local _fuse = ColdFusion.fuse(maid)
		local _new = _fuse.new
		local _bind = _fuse.bind
		local _import = _fuse.import

		local _Value = _fuse.Value
		local _Computed = _fuse.Computed

		local Graph = require(script.Parent)

		local XAxisLabel: State<string> = _Value("X-Axis")
		local YAxisLabel: State<string> = _Value("Y-Axis")

		local data = {}
		local count = 25
		for i = 1, count do
			data[HttpService:GenerateGUID(false)] = Vector2.new(math.random(), math.random() * i / count)
		end

		local Data: State<{ [string]: Vector2 }> = _Value(data)

		local CanvasSize: State<UDim2> = _Value(UDim2.fromOffset(400, 400))
		local Thickness: State<UDim> = _Value(UDim.new(0, 3))
		local CanvasColor: State<Color3> = _Value(Color3.fromHSV(1, 0, 0.9))
		local GridLineColor: State<Color3> = _Value(Color3.fromHSV(1, 0, 0.1))
		local Color: State<Color3> = _Value(Color3.fromHSV(1, 0.5, 0.9))

		local TextColor: State<Color3> = _Value(Color3.fromHSV(1, 0, 0.5))

		local graph = Graph(
			maid,
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
		graph.Parent = coreGui
	end)

	return function()
		maid:Destroy()
	end
end
