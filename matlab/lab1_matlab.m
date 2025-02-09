%Task 1: Image Rotation

%Inital code
function [Out] =  Rotate(In, Theta)

    %size of image
    [rows,cols,~] = size(In);
    
    %init output as black (zeros)
    Out = zeros(rows,cols);
    
    %find image centre
    centerX = (cols+1)/2;
    centery = (rows+1)/2;
    
    %create the tranformation
    transform = [cos(Theta),- sin(Theta), sin(Theta),cos(Theta)];
    
    %find inverse
    
    %loop through destination
    for destX = 1:cols
        for destY = 1:rows
            coordX = destX - centerX;
            coordY = destY - centery;
    
    
            source = transform\[coordX,coordY];
            sourceX = source(1);
            sourceY = source(2);
    
            x = round(sourceX+centerX);
            y = round(sourceY+centery);
    
            if x >=1 && x <=cols && y >=1 && y <=rows
                Out (destY, destX) = In(sourceY, sourceX);
            end
        end
    end
end
load clown
t = pi/4
Out = Rotate(clown, t)

%The solution from Professor Cheung:
ImageOut = rotate(ImageIn, Theta)
%Rotates the Image by Theta degrees.

function [Out] =  rotate(In, Theta)

%Work out Width and Height of Source image
width=size(In,1);
height=size(In,2);

%Work out the centre point of the image, since we want to rotate about this point.
cp = [round(size(In,1)/2), round(size(In,2)/2)];

%The forward transformation matrix
tm = [ cos(Theta), -sin(Theta) ;
    sin(Theta), cos(Theta) ]

%Calculate the reverse mapping by matrix inversion
rtm = inv (tm);

for y=1:height
    for x=1:width
        p =[x,y];			%Point on the destination image
        tp = round(rtm*(p-cp)'+cp');	%Calculate nearest corresponding point on the source image
        if tp(1)<1 | tp(2)<1 | tp(1)>width | tp(2)>height
            Out(x,y)=0;			%If we are outside the bounds of the image set to black
        else
            Out(x,y)=In(tp(1),tp(2));	%Else use the source image
        end
    end
end


%Task 2: Image Shearing
%Intial code
function [Out] = Shear (In, shearX, shearY)
    [h,w,~] = size(In);

    Out = zeros(h,w,"like", In);

    centerX = w/2;
    centerY = h/2;

    sMatrix = [1,shearX; shearY, 1];
    inverse = inv(sMatrix);

    for y = 1:h
        for x = 1:w
            newX =x-centerX;
            newY =y-centerY;

            input = inverse*[newX;newY];
            inputX = input(1)+centerX;
            inputY = input(2)+centerY;

            nearestx = round(inputX);
            nearesty = round(inputY);

            if nearestx >=1 && nearestx <=w && nearesty >=1 && nearesty <=h
                Out(y,x,:) = In(nearesty, nearestx,:);
            end
        end
    end
end

%Professor Cheung's solution:
function [Out] =  Shear(In, xshear, yshear)

%Work out Width and Height of Source image
width=size(In,1);
height=size(In,2);

%Work out the centre point of the image, since we want to shear about this point.
cp = [round(size(In,1)/2), round(size(In,2)/2)];

%The forward transformation matrix
tm = [ 1, xshear ;
    yshear, 1 ];

%Calculate the reverse mapping by inversion
rtm = inv (tm);

for y=1:height
    for x=1:width
        p =[x,y];			%Point on the destination image
        tp = round((p-cp)*rtm+cp);	%Calculate nearest corresponding point on the source image
        if tp(1)<1 | tp(2)<1 | tp(1)>width | tp(2)>height
            Out(x,y)=0;			%If we are outside the bounds of the image set to black
        else
            Out(x,y)=In(tp(1),tp(2));	%Else use the source image
        end
    end
end