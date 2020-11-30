x = input('Enter 1 for the keble dataset or 2 for the uttower dataset\n');

% Load in images depending on user input
if (x == 1)
    img1 = imread('keble1.png');
    img2 = imread('keble2.png');
elseif (x == 2)
    img1 = imread('uttower1.jpeg');
    img2 = imread('uttower2.jpeg');
end 
    
% Show the images in separate figures and call impixelinfo to see pixel
% coordinates on the figures
figure; imshow(img1); impixelinfo;
figure; imshow(img2); impixelinfo;

% Manually examine the images and find at least 4 pairs of points that are
% distinctive
if (x == 1)
    
    % Points for keble images
    PA = [339 3; 359 196; 223 157; 319 20; 170 104];
    PB = [242 24; 257 211; 126 170; 223 37; 73 116];
    

    % Pick a new point from the first image (Lumped into this if statement
    % to cut down on the number of if statements used
    PA_new_point = [336; 48; 1];
elseif (x == 2)
    % Points for uttower images
    PA = [444 516; 423 515; 456 317; 303 494; 487 413];
    PB = [905 547; 882 546; 904 340; 759 528; 944 437];
    
    PA_new_point = [84; 594; 1];
end

% Compute the homography between the points from PA and PB
H = estimate_homography(PA, PB);

% Apply homography to the newly selected point
PB_homography = apply_homography(PA_new_point, H);

% Plot the two points over the two images
figure;
subplot(1,2,1); imshow(img1);
hold on;
plot(PA_new_point(1), PA_new_point(2), '.g');
hold off;
subplot(1,2,2); imshow(img2);
hold on;
plot(PB_homography(1), PB_homography(2), '.y');
hold off;

% Don't want to force the grader to download these files! That would be a
% hassle
%
%if (x == 1)
%    saveas(gcf, 'keble_onept.png');
%elseif (x == 2)
%    saveas(gcf, 'uttower_onept.png');
%end

% Get number of rows and cols of img2
img2rows = size(img2,1);
img2cols = size(img2,2);

% Store the number of canvas rows
canvas_rows = 3*img2rows;
canvas_cols = 3*img2cols;

% Create a new canvas that is 3 times the length and width of img2
canvas = zeros(canvas_rows, canvas_cols, 3);

% Add img2 in the middle of the canvas
canvas(img2rows+1:(canvas_rows-img2rows), img2cols+1:(canvas_cols - img2cols),:) = img2;

% Convert canvas to uint8
canvas = uint8(canvas);

% For each pixel in img1...
for i=1:img2rows
    for j=1:img2cols
        
        % Apply estimated homography to each pixel p1 in img1 to determine
        % p2 location of pixel
        p2loc = apply_homography([j; i; 1], H);
        
        % Add img2rows to rows and img2cols to cols
        p2loc = p2loc + [img2cols; img2rows; 0];
        
        % Round both x- and y-coordinates up AND down
        cx = ceil(p2loc(1));
        cy = ceil(p2loc(2));
        fx = floor(p2loc(1));
        fy = floor(p2loc(2));
        
        % Add the 4 points to the canvas
        canvas(cy,cx,:) = img1(i,j,:);
        canvas(cy,fx,:) = img1(i,j,:);
        canvas(fy,cx,:) = img1(i,j,:);
        canvas(fy,fx,:) = img1(i,j,:);
    end
end

% Show the stitched image
figure;
imshow(canvas);

% Once again, don't want grader to download these files, so I'll comment
% them out!
%
%if (x == 1)
%    saveas(gcf, 'keble_mosaic.png');
%elseif (x == 2)
%    saveas(gcf, 'uttower_mosaic.png');
%end