classdef EditableImage < handle
    %EDITABLEIMAGE Class to represent editable image
    %   This class provides an utility for editable image.
    %   It will keep track of filtering applies to undo/redo image manip.
    
    properties(SetObservable)
        History = {}
        CurrentHistory = 1
    end
    
    methods
        function obj = EditableImage(path)
            %EDITABLEIMAGE Construct an instance of this class
            img = imread(path);
            obj.History = {img};
            obj.CurrentHistory = 1;
        end

        function img = getAfterImage(obj)
            img = obj.History{obj.CurrentHistory};
        end

        function img = getBeforeImage(obj)
            c = obj.CurrentHistory-1;
            if c < 1
                img = obj.History{1};
            else
                img = obj.History{c};
            end
        end

        function applyFilter(obj, filterName, args)
            img = obj.getAfterImage;
            switch filterName
                case 'brightness'
                    img = brightening(img, args);
                case 'negative'
                    img = negative(img);
                case 'log_transform'
                    img = log_transform(img, args);
                case 'power_transform'
                    img = power_transform(img, args);
                case 'contrast_stretching'
                    img = contrast_stretching(img);
                case 'histogram_equalization'
                    img = histogram_equalization(img);
                case 'histogram_specification'
                    img = histogram_specification(img, args);
                otherwise
                    error('unsupported filter: %s', filterName);
            end
            c = obj.CurrentHistory;
            obj.History = obj.History(1:c);
            % must change history before set current!!
            obj.History{end+1} = img;
            obj.CurrentHistory = obj.CurrentHistory + 1;
        end

        function back(obj)
            obj.changeHistory(obj.CurrentHistory - 1);
        end

        function redo(obj)
            obj.changeHistory(obj.CurrentHistory + 1);
        end

        function changeHistory(obj, idx)
            if idx > 0 && idx <= length(obj.History)
                obj.CurrentHistory = idx;
            end
        end
    end
end

