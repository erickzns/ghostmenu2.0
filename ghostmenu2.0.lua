-- Ghost Menu 2.0

local menu_open = false

function open_menu()
    menu_open = not menu_open
    if menu_open then
        print('Menu opened')
    else
        print('Menu closed')
    end
end

-- Bind the INSERT key to the open_menu function

function on_key_press(key)
    if key == "INSERT" then
        open_menu()
    end
end

-- Other menu functionalities can be added below

-- Example: Display options when the menu is open
function display_options()
    if menu_open then
        print('Option 1: ...')
        print('Option 2: ...')
        -- Add more options as needed
    end
end

-- Call display_options in a loop or in relevant parts of your code