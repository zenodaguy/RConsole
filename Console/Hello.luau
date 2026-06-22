-- This is an custom command example, you can delete this at anytime.

return {
	Name = "hello", -- Command Name
	Description = "Prints 'Hello, World!'.", -- Command Description
	Role = "Developer", -- Role Required to Run Command
	Run = function(...)
		print("Hello, World!")
	end
}