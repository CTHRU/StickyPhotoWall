--[[
	Sticky Photo Wall
	Copyright (c) 2022 Christoph Vanthuyne - https://github.com/CTHRU/StickyPhotoWall
	Released under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International license.
	(CC BY-NC-SA 4.0)
]]--

require "cairo"
require "demo_photo_wall"

local COLORS = {
    --[[ 
        Solid black BACKGROUND
    ]]
    BACKGROUND = { 0, 0, 0, 1 },
}

local FORMAT_PARAMETERS = { 
    ["ls-lg-st"] = {width = 478, height = 298, angle = 0},
    ["ls-lg-cw"] = {width = 486, height = 308, angle = 1, offset_x = -1, offset_y = -1},
    ["ls-lg-cc"] = {width = 486, height = 308, angle = -1, offset_x = -1, offset_y = -1},
    ["ls-md-st"] = {width = 360, height = 225, angle = 0},
    ["ls-md-cw"] = {width = 364, height = 231, angle = 1, offset_x = -1, offset_y = -1},
    ["ls-md-cc"] = {width = 364, height = 231, angle = -1, offset_x = -1, offset_y = -1},
    ["ls-sm-st"] = {width = 238, height = 148, angle = 0},
    ["ls-sm-cw"] = {width = 242, height = 154, angle = 1, offset_x = -1, offset_y = -1},
    ["ls-sm-cc"] = {width = 242, height = 154, angle = -1, offset_x = -1, offset_y = -1},
    ["pt-lg-st"] = {width = 298, height = 448, angle = 0},
    ["pt-lg-cw"] = {width = 308, height = 456, angle = 1, offset_x = -1, offset_y = 0},
    ["pt-lg-cc"] = {width = 308, height = 456, angle = -1, offset_x = -1, offset_y = 0},
    ["pt-md-st"] = {width = 218, height = 328, angle = 0},
    ["pt-md-cw"] = {width = 226, height = 334, angle = 1, offset_x = -1, offset_y = -1},
    ["pt-md-cc"] = {width = 226, height = 334, angle = -1, offset_x = -1, offset_y = -1},
    ["pt-sm-st"] = {width = 138, height = 208, angle = 0},
    ["pt-sm-cw"] = {width = 144, height = 212, angle = 1, offset_x = -1, offset_y = -1},
    ["pt-sm-cc"] = {width = 144, height = 212, angle = -1, offset_x = -1, offset_y = -1},
}

TAPE = setmetatable({}, {
	__index = {
		RANDOM = 0,
        CLEAR = 1,
        CLEAR2 = 2
	},
	__newindex = function() end
})

CROP = setmetatable({}, {
	__index = {
		CENTER = 0,
        TOP = 1,
        BOTTOM = 2,
        LEFT = 1,
        RIGHT = 2
	},
	__newindex = function() end
})

local TAPE_WIDTH_CENTER = 50

local working_dir
local photo_dir


function file_exists(filename)
    local f=io.open(filename, "r")
    if f ~= nil then 
        io.close(f) 
        return true 
    else 
        return false 
    end
end

--TODO: add functionality to open other file formats than png
function open_png_image(image_filename)
    local image = cairo_image_surface_create_from_png(image_filename)

    if cairo_surface_status(image) ~= CAIRO_STATUS_SUCCESS then
        print ("open_png_image - Failed to open image file " .. image_filename .. " (" .. cairo_surface_status(image) .. ")")
        cairo_surface_destroy(image)
        return nil
    end

    return image
end


function draw_shadow(cc, x, y, format)
    local image_filename = working_dir .. "resources/shadows/Shadow-" .. format .. ".png"
    local image = open_png_image(image_filename)
    if image == nil then return end

    print("draw_shadow - Displaying " .. image_filename)    
    cairo_set_source_rgba(cc, unpack(COLORS.BACKGROUND))
    cairo_set_source_surface(cc, image, 0 + x, 21 + y)
    cairo_paint(cc)

    cairo_surface_destroy(image)
end


--[[
    Resize and scale the horizontal oriented image to the frame format size.
]]
function resize_image(image, format, crop)
    print("resize_image - Resizing image")

    crop = crop or CROP.CENTER

    local straight_format = format:sub(0, format:len() - 2) .. "st"

    local frame_width = FORMAT_PARAMETERS[straight_format].width
    local frame_height = FORMAT_PARAMETERS[straight_format].height

    local frame_aspect_ratio = frame_width / frame_height

    local image_width = cairo_image_surface_get_width(image)
    local image_height = cairo_image_surface_get_height(image)

    local image_aspect_ratio = image_width / image_height

    print("resize_image - width: " .. frame_width .. " height: " .. frame_height)

    local resized_image = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, frame_width, frame_height)
    local resized_image_context = cairo_create(resized_image)

    -- Scale and resize the image to match the aspect ratio of the frame
    local scale_width
    local scale_height
    local x_offset = 0
    local y_offset = 0
    
    if (frame_aspect_ratio > image_aspect_ratio) then
        -- Image is too high, crop vertically
        scale_width = frame_width / image_width
        scale_height = frame_width / image_width
        
        y_offset = (frame_height / scale_height) - image_height

        if (crop == CROP.TOP) then
            -- Calculated Y offset value is already correct
        elseif (crop == CROP.BOTTOM) then
            y_offset = 0
        else
            -- Default crop top and bottom (center image in frame)
            y_offset = y_offset / 2
        end
    elseif (frame_aspect_ratio < image_aspect_ratio) then
        -- Image is too wide, crop horizontally
        scale_width = frame_height / image_height
        scale_height = frame_height / image_height

        x_offset = (frame_width / scale_width) - image_width 

        if (crop == CROP.LEFT) then
            -- Calculated X offset value is already correct
        elseif (crop == CROP.RIGHT) then
            x_offset = 0
        else
            -- Default crop left and right (center image in frane)
            x_offset = x_offset / 2
        end
    else
        -- Image aspect ratio matches frame, scale only
        scale_width = frame_width / image_width
        scale_height = frame_height / image_height
    end

    cairo_scale(resized_image_context, scale_width, scale_height)    
    cairo_set_source_rgba(resized_image_context, unpack(COLORS.BACKGROUND))
    cairo_set_source_surface(resized_image_context, image, x_offset, y_offset)
    cairo_paint(resized_image_context)

    cairo_destroy(resized_image_context)

    if cairo_surface_status(resized_image) ~= CAIRO_STATUS_SUCCESS then
        print ("resize_image - Failed to resize image (" .. cairo_surface_status(framed_image) .. ")")
        cairo_surface_destroy(resized_image)
        cairo_surface_destroy(image)  
        return
    end

    return resized_image
end


function frame_image(image, format, crop)
    print("frame_image - Framing image")

    local frame_width = FORMAT_PARAMETERS[format].width
    local frame_height = FORMAT_PARAMETERS[format].height
    local frame_angle = FORMAT_PARAMETERS[format].angle

    local frame_aspect_ratio = frame_width / frame_height

    print("frame_image - width: " .. frame_width .. " height: " .. frame_height .. " angle: " .. frame_angle)

    local framed_image = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, frame_width, frame_height)
    local framed_image_context = cairo_create(framed_image)

    -- resize and scale the image to the frame format size
    local resized_image = resize_image(image, format, crop)

    local image_width = cairo_image_surface_get_width(resized_image)
    local image_height = cairo_image_surface_get_height(resized_image)

    -- Rotate the image in case of a non-straight frame
    if (frame_angle ~= 0) then
        cairo_translate(framed_image_context, (image_width / 2.0), (image_height / 2.0))
        cairo_rotate(framed_image_context, frame_angle * math.pi / 180)
        cairo_translate(framed_image_context, -(image_width / 2.0), -(image_height / 2.0))
    end

    cairo_set_source_rgba(framed_image_context, unpack(COLORS.BACKGROUND))
    cairo_set_source_surface(
        framed_image_context, 
        resized_image, 
        (frame_width - image_width) / 2, 
        (frame_height - image_height) / 2)
    cairo_paint(framed_image_context)

    cairo_surface_destroy(resized_image)
    cairo_destroy(framed_image_context)

    if cairo_surface_status(framed_image) ~= CAIRO_STATUS_SUCCESS then
        print ("frame_image - Failed to frame image (" .. cairo_surface_status(framed_image) .. ")")
        cairo_surface_destroy(framed_image)        
        return
    end

    return framed_image
end


function draw_photo(cc, image, x, y, format, crop)
    if image == nil then return end

    local offset_x = FORMAT_PARAMETERS[format].offset_x or 0
    local offset_y = FORMAT_PARAMETERS[format].offset_y or 0

    -- Fit the image to the frame
    local framed_image = frame_image(image, format, crop)

    print("draw_photo - Displaying photo")

    cairo_set_source_rgba(cc, unpack(COLORS.BACKGROUND))
    cairo_set_source_surface(cc, framed_image, 4 + x + offset_x, 21 + y + offset_y)
    cairo_paint(cc)

    cairo_surface_destroy(framed_image)
    cairo_surface_destroy(image)
end


function draw_frame(cc, x, y, format)
    local image_filename = working_dir .. "resources/frames/Frame-" .. format .. ".png"
    local image = open_png_image(image_filename)
    if image == nil then return end

    print("draw_frame - Displaying " .. image_filename)    
    cairo_set_source_rgba(cc, unpack(COLORS.BACKGROUND))
    cairo_set_source_surface(cc, image, 3 + x, 20 + y)
    cairo_paint(cc)

    cairo_surface_destroy(image)
end


--TODO: Ameliorate tape visibility by changing opacity?
function draw_tape(cc, x, y, format, tape)
    tape = tape or TAPE.RANDOM
    local image_filename = working_dir .. "resources/tape/TapeClear"
 
    if tape == TAPE.RANDOM then
        tape = math.random(1, 2)
    end

    if tape > 1 then
        image_filename = image_filename .. tape .. ".png"
    else
        image_filename = image_filename .. ".png"
    end 
    
    local image = open_png_image(image_filename)
    if image == nil then return end

    local width = FORMAT_PARAMETERS[format].width

    print("draw_tape - Displaying " .. image_filename)    
    cairo_set_source_rgba(cc, unpack(COLORS.BACKGROUND))
    cairo_set_source_surface(cc, image, x + (width / 2) - TAPE_WIDTH_CENTER, 0 + y)
    cairo_paint(cc)

    cairo_surface_destroy(image)
end


--TODO: add functionality to auto select the most appropriate frame orientation
function draw_sticky_photo(cc, photo_filename, x, y, format, tape, crop)
    x = x or 0
    y = y or 0

    local photo_surface = open_png_image(photo_filename)
    if photo_surface == nil then return end

    if format then
        if FORMAT_PARAMETERS[format] == nil then
            print("Invalid format " .. format .. " for photo " .. photo_filename)
            return
        end
    else        
        -- Select a default portrait or landscape format based on the orientation of the photo
        width = cairo_image_surface_get_width(photo_surface)
        height = cairo_image_surface_get_height(photo_surface)

        if (height >= width) then
            format = "pt-lg-st"
        else
            format = "ls-lg-st"
        end
    end

    draw_shadow(cc, x, y, format)
    draw_photo(cc, photo_surface, x, y, format, crop)
    draw_frame(cc, x, y, format)
    draw_tape(cc, x, y, format, tape)
end


function conky_config(config_working_directory)
    print("conky_config - Setting working directory to " .. config_working_directory)
    working_dir = config_working_directory
    photo_dir = working_dir .. "/resources/photos/"

    math.randomseed(os.time())
end


--FIXME: update screen when one of the configuration files has been changed / reloaded (without changing update interval)
--TODO: create function to randomly select pictures to display from the selected folder
--TODO: add functionality to auto lay-out all images in a given folder
--TODO: add configuration GUI
--TODO: use better logging than 'print'
function conky_main()
    if conky_window == nil then
        print("conky_main - No conky window")
        return
    end

    -- Create an Xlib surface
    print("conky_main - Creating surface")
    local cs = cairo_xlib_surface_create(
        conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height
    )

    -- Create a drawing context
    local cc = cairo_create(cs)

    if (file_exists("my_photo_wall.lua")) then
        require "my_photo_wall"
        if draw_my_photo_wall ~= nil then
            draw_my_photo_wall(cc, photo_dir)
        else
            print("--------------------------------")
            print("WARNING: Sticky Photo Wall could not find draw_my_photo_wall() function in my_photo_wall.lua")
            print("Displaying demo. See README.md for more information.")
            print("--------------------------------")
            draw_demo_photo_wall(cc, photo_dir)
        end        
    else
        print("--------------------------------")
        print("WARNING: Sticky Photo Wall could not find the file my_photo_wall.lua")
        print("Displaying demo. See README.md for more information.")
        print("--------------------------------")
        draw_demo_photo_wall(cc, photo_dir)
    end

    -- Cleanup context and surface
    cairo_destroy(cc)
    cairo_surface_destroy(cs)
end
