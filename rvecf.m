%The "rvecf" function calculates the resultant of any number of vectors
%regardless the unit (meter, Newton, pound, dyne, etc.).  Vectors must be
%inputted into this function as row or column vectors, where each element
%of vector M is a magnitude (in whatever units the problem contains) and
%each element of vector t is an angle in degrees with respect to the
%positive x-axis.  The index value of M must correspond to the index value
%of t at which the M is acting (M1 corresponds to t1, M2 corresponds to t2,
%etc.).  Units must be consistent throughout vector M.  Also, it should be
%noted that this function is only valid for solving two-dimensional
%problems.
%
%This function also contains a feature that allows the user to input a row
%or column vector L as a third input.  This feature is meant for
%calculating net torque, and the L vector can be omitted if torque is not
%involved in the problem and a resultant in translational motion is needed
%as output (as described in the previous paragraph).  Similarly, the index
%value for the L vector corresponds to the lever arm for the magnitude and
%angle with the same index value in vectors M and t, respectively.  Units
%should be consistent throughout the L vector.  It should also be noted
%that, for torque problems, the positive x-axis and the origin should be
%coincident with the lever arm and the axis of rotation, respectively,
%because the equation used is tau = r * F * sind(theta).
%
%For example, if M is a vector of magnitudes in units and t is a vector of
%angles in degrees with respect to the positive x-axis, this function will
%calculate the resultant vector R, directed at an angle d with respect to
%the positive x-axis, of M magnitudes directed at t angles with respect to
%the positive x-axis.  For another example, if M is a vector of forces in
%Newtons and t is a vector of the angles at which those forces act in
%degrees with respect to the positive x-axis, then L would be a vector of
%lever arms in meters, with which data this function would calculate the
%net torque R and the direction of rotation d.
%
%This function was made by Ian J. Silberzweig. 05/17/2017.
%Edited starting on 10/12/2017 to solve multivariate equations.
function rvecf(M,t,L)
if exist('L') == 0
    if isvector(M) == 0 || isvector(t) == 0
        errorInputNotVec.message = 'Error:  Inputs must be vectors.';
        errorInputNotVec.identifier = 'rvecf:InputsNotVex';
        error(errorInputNotVec)
        return
    elseif length(M) ~= length(t)
        errorMissingVar.message = 'Error:  Each input vector must contain the same number of elements.';
        errorMissingVar.identifier = 'rvecf:VarIsMissing';
        error(errorMissingVar)
        return
    else
        TempMatX = zeros(1,length(M)); TempMatY = zeros(1,length(M));
        for n = 1 : length(M)
            TempMatX(1,n) = M(n) * cosd( t(n) ); TempMatY(1,n) = M(n) * sind( t(n) ); %calculating x and y vector components
            if t(n) < 0 || t(n) > 90 %reference angles must be accounted for if theta is outside of the first quadrant
                warning('Solution may be incorrect.  Verify geometry and reference angles.')
            end
        end
        STempMatX = cumsum(TempMatX); STempMatY = cumsum(TempMatY); %summing x and y vector components
        SRx = STempMatX(1,end); SRy = STempMatY(1,end); %extracting sum of x and y components from temporary row vectors
        R = sqrt( (SRx^2) + (SRy^2) ); d = atand( SRy / SRx ); %resultant magnitude and direction
    end
else
    if isvector(M) == 0 || isvector(t) == 0 || isvector(L) == 0
        errorInputNotVec.message = 'Error:  Inputs must be vectors.';
        errorInputNotVec.identifier = 'rvecf:InputsNotVex';
        error(errorInputNotVec)
        return
    elseif length(M) ~= length(t) || length(M) ~= length(L) || length(t) ~= length(L)
        errorMissingVar.message = 'Error:  Each input vector must contain the same number of elements.';
        errorMissingVar.identifier = 'rvecf:VarIsMissing';
        error(errorMissingVar)
        return
    else
        TempMatR = zeros(1,length(M));
        for n = 1 : length(M)
            TempMatR(1,n) = L(n) * M(n) * sind( t(n) ); %calculating each torque
            if t(n) < 0 || t(n) > 90 %reference angles must be accounted for if theta is outside of the first quadrant
                warning('Solution may be incorrect.  Verify geometry and reference angles.')
            end
        end
        STempMatR = cumsum(TempMatR); %summing torques
        R = STempMatR(1,end); %extracting the sum of the torques
        if R < 0
            d = num2str('Clockwise Rotation');
        elseif R > 0
            d = num2str('Counterclockwise Rotation');
        else
            d = num2str('System Is In Equilibrium');
        end
    end
end
R,d
end