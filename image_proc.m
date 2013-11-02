max_x_col = 0 
max_y_row = 0
folder_count = 3
for folder_count = 1:62
for image_count = 1:55
        s = sprintf('C:/Users/Mgenius/Desktop/English/Hnd/Img/Sample0%02d/img0%02d-0%02d.png',folder_count,folder_count,image_count);
        s;
        Img = imread(s);
        J = rgb2gray(Img);
  
    %size(C)

    binary_image = im2bw(J, graythresh(J));
    %imshow(binary_image);
    image_edge = edge(uint8(binary_image));

    se = strel('square',2); 
    image_edge2 = imdilate(image_edge, se); 
    %imshow(Iedge2); 

    Ifill= imfill(image_edge2,'holes'); 
    imshow(Ifill) 



    [Ilabel, num] = bwlabel(Ifill);
    num;
    imageProps = regionprops(Ilabel);
    Ibox = imageProps.BoundingBox;

    %imshow(J);
    hold on;
    rectangle('position', Ibox(:), 'edgecolor' , 'r');
    disp(Ibox(:));

    if max_x_col < Ibox(1)
        max_x_col = Ibox(1);
    end
    
    if max_y_row < Ibox(1)
        max_y_row = Ibox(1);
    end
    
    %image_2d_array = zeros(900,1200);
    %for i=1:900
    %       for j = 1:1200
    %           image_2d_array(i,j) = J(1200*(i-1)+j);
    %       end
    %end
    
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
    
    
end
end