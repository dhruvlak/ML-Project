%%%%%code to crop centered images and extrct new feature vectors
max_x = 750;
max_y = 840;
y1 = 31;
y2 = 870;
x1 = 226;
x2 = 975;
for folder_count = 1:62
for image_count = 1:55
        
    disp([folder_count image_count]);
    %%%%%%taking input
        s = sprintf('C:/Users/Mgenius/Desktop/English/Preprocessing/Img/img0%02d-0%02d.png',folder_count,image_count);
        J = imread(s);
        %size(J)
        
        newImage = J(y1:y2,x1:x2);
        
        s = sprintf('C:/Users/Mgenius/Desktop/English/Preprocessing/croppedImages/img0%02d-0%02d.png',folder_count,image_count);
        imwrite(newImage, s);
    
    %%%%%%code for extracting features
    chunkX = 30;
    chunkY = 40;
    Blocks = permute(reshape(newImage, [chunkY, 840/chunkY, chunkX, 750/chunkX]), [1, 3, 2, 4]);
    C = zeros(840/chunkY, 750/chunkX);
    for i = 1:840/chunkY
        for j = 1:750/chunkX
            C(i,j) = mean(mean(Blocks(:, :, i, j)));
        end
    end


    r = sprintf('C:/Users/Mgenius/Desktop/English/Preprocessing/croppedImageFeatures/img0%02d-0%02d.txt',folder_count,image_count);
    dlmwrite(r, C );
    
    t = sprintf('C:/Users/Mgenius/Desktop/English/Preprocessing/Features.txt');
    newC = reshape(C,1,525);
    dlmwrite(t,newC,'newline','pc','-append');
 
end
end
