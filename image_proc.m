max_x_col = 0; 
max_y_row = 0;
folder_count = 3;
max_image_x = [];
max_image_y = [];
for folder_count = 1:62
for image_count = 1:55
        
    disp([folder_count image_count]);
    %%%%%%taking input
        s = sprintf('C:/Users/Mgenius/Desktop/English/Hnd/Img/Sample0%02d/img0%02d-0%02d.png',folder_count,folder_count,image_count);
        s;
        Img = imread(s);
        J = rgb2gray(Img);
  
    %%%%%code to finde the bounding box
    binary_image = im2bw(J, graythresh(J));
    image_edge = edge(uint8(binary_image));

    se = strel('square',2); 
    image_edge2 = imdilate(image_edge, se); 
    
    Ifill= imfill(image_edge2,'holes'); 
  


    [Ilabel, num] = bwlabel(Ifill);
    num;
    imageProps = regionprops(Ilabel);
    Ibox = imageProps.BoundingBox;

    %imshow(J);
    %hold on;
    %rectangle('position', Ibox(:), 'edgecolor' , 'r');
    

    %%%%%code to find max of x and max of y
    if max_x_col < Ibox(3)
        max_x_col = Ibox(3);
        max_image_x = [image_count folder_count];
    
    end
    
    if max_y_row < Ibox(4)
        max_y_row = Ibox(4);
        max_image_y = [image_count folder_count];
    
    end
    
    %%%%%code for shifting images to the center
    
    %{
    cent = [ Ibox(1)+Ibox(3)/2 , Ibox(2) + Ibox(4)/2 ];
    disp(cent);
    
    
    shiftX = 600 - int32(cent(1))
    
    shiftY = 450 - int32(cent(2))
    
    size(J)
    if shiftY > 0
        newImage = [J(end-shiftY+1:end,:); J(1:end-shiftY,:)];
    else
        newImage = [J(-shiftY+1:end,:); J(1:-shiftY,:)];
    end
    if shiftX > 0
        newImage = [newImage(:,end-shiftX+1:end) newImage(:,1:end-shiftX)];
    else
        newImage = [newImage(:,-shiftX+1:end) newImage(:,1:-shiftX)];
    end
    
    imshow(newImage)
    hold on;
    rectangle('position', Ibox(:), 'edgecolor' , 'r');
    
    %cent = imageProps.Centroid;

    

    chunkX = 40;
    chunkY = 30;
    Blocks = permute(reshape(newImage, [chunkY, 900/chunkY, chunkX, 1200/chunkX]), [1, 3, 2, 4]);
    C = zeros(900/chunkY, 1200/chunkX);
    for i = 1:900/chunkY
        for j = 1:1200/chunkX
            C(i,j) = mean(mean(Blocks(:, :, i, j)));
        end
    end

    Centroid = imageProps.Centroid;
    newCentroid = [Centroid(1)+shiftX, Centroid(2)+shiftY];
    
    %output to different files
        s = sprintf('C:/Users/Mgenius/Desktop/English/Preprocessing/Img/img0%02d-0%02d.png',folder_count,image_count);
        r = sprintf('C:/Users/Mgenius/Desktop/English/Preprocessing/Features/img0%02d-0%02d.txt',folder_count,image_count);
        t = sprintf('C:/Users/Mgenius/Desktop/English/Preprocessing/OtherFeatures/img0%02d-0%02d.txt',folder_count,image_count);
        
        imwrite(newImage, s);
        dlmwrite(r, C );
        dlmwrite(t,'Bounding Box:','delimiter','');
        dlmwrite(t,[Ibox(3) Ibox(4)],'-append');
        dlmwrite(t,'Centroid:','delimiter','','-append');
        dlmwrite(t,newCentroid, 'delimiter', ',', '-append');
    
    %}

end
end

disp(max_x_col);
disp(max_y_row);
disp(max_image_x);

disp(max_image_y);
dlmwrite('C:/Users/Mgenius/Desktop/English/Preprocessing/maxXY.txt',[max_x_col max_y_row max_image_x(1) max_image_x(2) max_image_y(1) max_image_y(2)]);
