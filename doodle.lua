-- Doodle: press a hotkey, sketch, press Enter, and the sketch is on the clipboard as a PNG.
--
-- Load from ~/.hammerspoon/init.lua with:
--   dofile(os.getenv("HOME") .. "/claude-doodle/doodle.lua")

local M = {
    hotkey = { { "ctrl", "alt" }, "D" },
    width = 900,
    height = 600,
    saveDir = os.getenv("HOME") .. "/Doodles",
}

local here = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
local view, previousWindow

local function readFile(path)
    local f = assert(io.open(path, "rb"))
    local data = f:read("a")
    f:close()
    return data
end

local function close()
    -- Grab this first: deleting the view fires the "closing" callback, which clears it.
    local returnTo = previousWindow
    if view then
        view:delete()
        view = nil
    end
    previousWindow = nil
    if returnTo then returnTo:focus() end
end

-- Save the PNG as a backup and put it on the clipboard as both PNG and TIFF,
-- so it pastes into terminals, browsers and native apps alike.
local function copyPng(png)
    hs.fs.mkdir(M.saveDir)
    local path = M.saveDir .. "/doodle-" .. os.date("%Y-%m-%d_%H%M%S") .. ".png"
    local f = assert(io.open(path, "wb"))
    f:write(png)
    f:close()

    local items = { ["public.png"] = png }
    local img = hs.image.imageFromPath(path)
    local tiffUrl = img and img:encodeAsURLString(false, "TIFF")
    if tiffUrl then
        items["public.tiff"] = hs.base64.decode(tiffUrl:match(",(.*)$"))
    end
    hs.pasteboard.writeAllData(items)
    return path
end

local function onMessage(msg)
    local body = msg.body
    if body.action == "send" then
        local ok, err = pcall(copyPng, hs.base64.decode(body.png))
        close()
        if ok then
            hs.alert.show("Doodle copied - paste it")
        else
            hs.alert.show("Doodle failed: " .. tostring(err))
        end
    elseif body.action == "cancel" then
        close()
    elseif body.action == "paste" then
        -- Hammerspoon has no Edit menu, so the page can't always see the clipboard itself.
        local img = hs.pasteboard.readImage()
        if img then
            view:evaluateJavaScript("addImage('" .. img:encodeAsURLString(false, "PNG") .. "')")
        else
            view:evaluateJavaScript("toast('No image on the clipboard')")
        end
    end
end

function M.open()
    -- Hotkey while open just brings the canvas back to the front.
    if view then
        view:show():bringToFront(true)
        view:hswindow():focus()
        return
    end

    previousWindow = hs.window.focusedWindow()
    local screen = (previousWindow and previousWindow:screen()) or hs.mouse.getCurrentScreen()
    local f = screen:frame()
    local rect = {
        x = f.x + (f.w - M.width) / 2,
        y = f.y + (f.h - M.height) / 2,
        w = M.width,
        h = M.height,
    }

    local content = hs.webview.usercontent.new("doodle"):setCallback(onMessage)
    view = hs.webview.new(rect, { developerExtrasEnabled = true }, content)
        :windowTitle("Doodle")
        :windowStyle({ "titled", "closable", "resizable" })
        :allowTextEntry(true)
        :level(hs.drawing.windowLevels.floating)
        :windowCallback(function(action)
            if action == "closing" then
                view = nil
                previousWindow = nil
            end
        end)
        :html(readFile(here .. "canvas.html"))
        :show()

    hs.focus()
    view:bringToFront(true)
    local win = view:hswindow()
    if win then win:focus() end
end

hs.hotkey.bind(M.hotkey[1], M.hotkey[2], M.open)

return M
