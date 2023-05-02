STYLE_GUIDE_PATH = "out/StyleGuide/init.luau"
with open(STYLE_GUIDE_PATH, "r") as read_file:
	content = read_file.read()
	with open(STYLE_GUIDE_PATH, "w") as write_file:
		content = content.replace(
			"local PseudoEnum = require(game:WaitForChild(\"PseudoEnum\"))", 
			"local Package = script.Parent; assert(Package); local PseudoEnum = require(Package:WaitForChild(\"PseudoEnum\"))"
		)
		write_file.write(content)
