classdef Histogram < handle
    properties
        HistogramMap
    end

    methods
        function obj = Histogram(image)
            %HISTOGRAM Construct an instance of this class
            obj.HistogramMap = Histogram.calc(image);
        end
    end

    methods(Static)
        function max_pixel = get_max_pixel(hist_map)
            for i = 256:-1:1
                if hist_map(i) ~= 0
                    max_pixel = i;
                    break
                end
            end
        end

        function min_pixel = get_min_pixel(hist_map)
            for i = 1:256
                if hist_map(i) ~= 0
                    min_pixel = i;
                    break
                end
            end
        end

        function histogram_map = calc(image)
            % Catatan: index digeser satu ke kanan
            image_size = get_image_size(image);
            histogram_map = zeros(image_size(3), 256, "uint64");
            for i = 1:image_size(1)
                for j = 1:image_size(2)
                    for k = 1:image_size(3)
                        index = uint16(image(i, j, k)) + 1;
                        histogram_map(k, index) = histogram_map(k, index) + 1;
                    end
                end
            end
        end
    end
end
