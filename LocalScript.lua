local Status = game:GetService("ReplicatedStorage"):WaitForChild("Status")

script.Parent.Text = Status.Value

--Fires function on change of status value
Status:GetPropertyChangedSignal("Value"):Connect(function()
	script.Parent.Text = Status.Value
	
end)