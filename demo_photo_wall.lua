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
    ]]    
    demo_dir = photo_dir .. "demo/"
    draw_sticky_photo(cc, demo_dir .. "Sticky.png", 10, 25, "ls-sm-cw")
    draw_sticky_photo(cc, demo_dir .. "Wall.png", 470, 0, "pt-sm-st")
    draw_sticky_photo(cc, demo_dir .. "Photo.png", 240, 35, "ls-sm-cc")
end