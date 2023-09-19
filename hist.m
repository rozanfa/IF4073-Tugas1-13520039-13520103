function min_val = get_min_pixel_values(histogram_map)
    for i = 1:256
        if histogram_map(i) ~= 0
            min_val = i;
            break
        end
    end
end

function max_val = get_max_pixel_values(histogram_map)
    for i = 256:-1:1
        if histogram_map(i) ~= 0
            max_val = i;
            break
        end
    end
end

function show_hist(image, name)
    hists = get_histogram_maps(image);
    for i = 1:size(hists)
        figure("Name", name); bar(hists(i, :));
    end
end

function histogram_map = get_histogram_maps(image)
    % Catatan: index digeser satu ke kanan
    image_size = get_image_size(image);
    histogram_map = zeros(image_size(3), 256, "uint32");
    for i = 1:image_size(1)
        for j = 1:image_size(2)
            for k = 1:image_size(3)
                index = uint16(image(i, j, k)) + 1;
                histogram_map(k, index) = histogram_map(k, index) + 1;
            end
        end
    end
end
