function res = histogram_spesification(r, reference)

    % Convert images to double
    r = double(r);
    reference = double(reference);
    
    % Get image attributes
    image_size = get_image_size(r);
    value_count_map = zeros(image_size(3), 256, "uint32");
    pixel_count = image_size(1) * image_size(2);
    
    % Get reference image attributes
    reference_image_size = get_image_size(reference);
    reference_value_count_map = zeros(reference_image_size(3), 256, "uint32");
    reference_pixel_count = reference_image_size(1) * reference_image_size(2);
    
    % Initialize maps
    equalization_map = zeros(image_size(3), 256, "uint32");
    reference_equalization_map = zeros(image_size(3), 256, "uint32");
    specification_map = zeros(image_size(3), 256, "uint32");
    
    % Initialize result image
    res = zeros(image_size);
    
    % Loop through each channel
    for k = 1:image_size(3)
        
        % Count every value in the image
        value_count_map(k, 1) = sum(sum(r(:,:,k) == 0));
        for n = 1:255
            value_count_map(k, n+1) = sum(sum(r(:,:,k) == n)) + value_count_map(k, n);
        end
        
        % Count every value in the reference image
        reference_value_count_map(k, 1) = sum(sum(r(:,:,k) == 0));
        for n = 1:255
            reference_value_count_map(k, n+1) = sum(sum(reference(:,:,k) == n)) + reference_value_count_map(k, n);
        end
        
        % Create equalization map for the image
        for i = 1:256
            equalization_map(k, i) = value_count_map(k, i) * 255 / pixel_count;
        end
        
        % Create equalization map for the reference image
        for i = 1:256
            reference_equalization_map(k, i) = reference_value_count_map(k, i) * 255 / reference_pixel_count;
        end
        
        % Create specification map
        for i = 1:256
            disp(get_nearest_value(i, reference_equalization_map(k, :)));
            specification_map(k, i) = get_nearest_value(i-1, reference_equalization_map(k, :));
        end
        
        % Apply specification map to the image
        for i = 1:image_size(1)
            for j = 1:image_size(2)
                res(i,j,k) = specification_map(k, equalization_map(k, r(i,j,k) + 1) + 1);
            end
        end
    end
    
    % Convert result image to uint8
    res = uint8(res);
end


function nearest_value = get_nearest_value(target_value, array)
    % Function to get nearest value from an array using binary search
    
    array = int16(array);
    low = 1;
    high = 256;
    
    nearest_value = array(1);
    diff = abs(array(1) - target_value);
    
    % Binary search
    while low <= high
        mid = floor((low + high) / 2);
        current_element = array(mid);
        
        if current_element == target_value
            nearest_value = current_element;
            return;
        end
        
        if abs(current_element - target_value) < diff
            nearest_value = current_element;
            diff = abs(current_element - target_value);
        end
        
        if current_element < target_value
            low = mid + 1;
        else
            high = mid - 1;
        end
    end
end