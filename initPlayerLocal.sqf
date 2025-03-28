// Add the scroll wheel action to the player
player addAction [
    "<t color='#00FF00'>Call Support Helicopter</t>", // Action name with green text
    {
        [] execVM "scripts\helicrate.sqf"; // Execute the helicopter script
    },
    nil, // Arguments
    1.5, // Priority
    true, // Show Window
    true, // Hide On Use
    "", // Shortcut
    "true", // Condition
    50 // Radius
]; 