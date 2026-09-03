-- ASUS Vivobook 144Hz Screen Config
hl.monitor({
    output = "eDP-1",
    mode = "1920x1200@144",
    position = "0x0",
    scale = 1
})

-- Myanmar (mm) + US English Keyboard Layout with Win+Space Toggle
hl.config({
    input = {
        kb_layout = "us,mm",
        kb_options = "grp:win_space_toggle",
    }
})
