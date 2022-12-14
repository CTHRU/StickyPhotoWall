function draw_demo_photo_wall(cc, photo_dir)
    --[[
        Add your photos below this comment block.

        Syntax:

        draw_sticky_photo(cc, photo_dir .. "your_photo.png", x, y, format)

        Example:

        draw_sticky_photo(cc, photo_dir .. "beautiful_photo.png", 10, 20, "pt-lg-cc")

        Parameters:
        cc: provided drawing context (fixed)
        photo_dir: provided default directory where your photos are stored
        "your_photo.png": replace your_photo with the name of your photo png image in the photo_dir
        x: x coordinate (horizontal) of the upper left hand corner of the sticky photo.
            Note: this is relative to the parameters alignment, gap_x and minimum_width 
            in the Conky config file (sticky_photo_wall.conky).
        y: y coordinate (vertical) of the upper left hand corner of the sticky photo.
            Note: this is relative to the parameters alignment, gap_x and minimum_width 
            in the Conky config file (sticky_photo_wall.conky).
        format: a string representation of the format to use to display the photo.
            The format parameter is formed as follows:
            "<orientation>-<size>-<rotation>"

            Where:
            <orientation>: the orientation of the photo.
            pt for portrait orientation.
            ls for landscape orientation.
            <size>: the size of the photo.
            sm for a small photo.
            md for a medium photo.
            lg for a large photo.
            <rotation>: determines whether the photo is sticked straight or crooked.
            st: for straight application.
            cw: for crooked clockwise application (rotated to the right).
            cc: for crooked counterclockwise application (rotated to the left).

            Example: "pt-lg-cc" means portrait orientation, large size, skewed counterclockwise
        tape: optional parameter to specify which tape image to use. Use one of the following options:
            TAPE.RANDOM: (default) Use a random tape image.
            TAPE.CLEAR: use the first tape image.
            TAPE.CLEAR2: use the second tape image.
        crop: optional parameter to specify which part of the image to crop when the resized image is 
        wider or higher than the frame. By default, cropping will be around the center of the image.
        To crop images that are wider than the frame after resizing, use:
            CROP.CENTER: (default) Crop the image around the center (crop left and right equally).
            CROP.LEFT: Crop the image left.
            CROP.RIGHT: Crop the image right.
        To crop images that are higher than the frame after resizing, use:
            CROP.CENTER: (default) Crop the image around the center (crop top and bottom equally).
            CROP.TOP: Crop the top of the image.
            CROP.BOTTOM: Crop the bottom of the image.
    ]]    
    demo_dir = photo_dir .. "demo/"
    draw_sticky_photo(cc, demo_dir .. "Sticky.png", 10, 25, "ls-sm-cw", TAPE.CLEAR)
    draw_sticky_photo(cc, demo_dir .. "Wall.png", 470, 0, "pt-sm-st")
    draw_sticky_photo(cc, demo_dir .. "Photo.png", 240, 35, "ls-sm-cc", TAPE.CLEAR2)
end