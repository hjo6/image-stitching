function H = estimate_homography(PA,PB)

    % Get the number of rows from PA (or PB)
    rows = size(PA,1);

    % Set up A, who will have 2 * N number of rows, where N is the number
    % of rows from both PA and PB, and 9 columns
    A = zeros((2*rows),9);
    
    % Populate A with equations
    for i=1:rows*2
        
        % Since the x/x' values are the first to show up in A, the odd
        % numbered indices work with x and x'. If mod(i,2) is 0, then the
        % y-coordinate equations are to be solved
        if (mod(i,2))
            
            % Get the coordinates from PA and PB at the ith row. x
            % coordinates correspond to column 1 and y coordinates
            % correspond to column 2. y2/y' isn't used in finding the
            % equations for the x-coordinates.
            x1 = PA(ceil(i/2),1);
            x2 = PB(ceil(i/2),1);
            y1 = PA(ceil(i/2),2);
            
            A(i,1) = -x1;
            A(i,2) = -y1;
            A(i,3) = -1;
            
            % Columns 4-6 when calculating equations for the x-coordinates
            % remain 0, so we don't worry about updating them. Move onto
            % columns 7-9
            A(i,7) = x1 * x2;
            A(i,8) = y1 * x2;
            A(i,9) = x2;
        else
            
            % Get the coordinates from PA and PB at the ith row. x
            % coordinates correspond to column 1 and y coordinates
            % correspond to column 2. x2/x' isn't used in finding the
            % equations for the y-coordinates.
            x1 = PA(ceil(i/2),1);
            y1 = PA(ceil(i/2),2);
            y2 = PB(ceil(i/2),2);
            
            % Like columns 4-6 for the x-coordinates, columns 1-3 for
            % finding the equations for the y-coordinates remain 0, so
            % no reason to update them. Start at column 4
            A(i,4) = -x1;
            A(i,5) = -y1;
            A(i,6) = -1;
            A(i,7) = x1 * y2;
            A(i,8) = y1 * y2;
            A(i,9) = y2;
        end
    end
    
    [~, ~, V] = svd(A);
    h = V(:, end);
    H = reshape(h, 3, 3)';
end

