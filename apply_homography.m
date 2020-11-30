function [p2] = apply_homography(p1, H)

    % Compute p2 = H * p1 using regular matrix multiplication
    p2 = H * p1;
    
    % Store w, the value in the 3rd row, from p2
    w = p2(3);
    
    % Divide all values in p2 by w
    p2 = p2./w;
end

