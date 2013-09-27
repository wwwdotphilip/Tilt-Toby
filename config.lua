if display.pixelHeight > 960 then
    application = {
        content = {
            width = 640,
            height = 1136,
--            scale = "zoomStretch",
            scale = "letterBox",
            fps = 30,
            antialias = "true",
        },
        imageSuffix = {
            ["@2x"] = 2,
        },
    }
else
    application = {
        content = {
            width = 640,
            height = 960,
--            scale = "zoomStretch",
            scale = "letterBox",
            fps = 30,
            antialias = "true",
        },
        imageSuffix = {
            ["@2x"] = 2,
        },
    }
end