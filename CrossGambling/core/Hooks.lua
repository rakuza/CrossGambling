Hooks = {}
function Hooks:click_LastCall(Chat_Method) 
    Utils:SendAlert("LastCall", Chat_Method)
end