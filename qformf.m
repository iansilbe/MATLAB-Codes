%The "qformf" function calculates the roots of a quadratic equation,
%provided that the inputs a, b and c are the coefficients in the standard
%quadratic equation form: ax^2 + bx + c = 0.  Also, the discriminant must
%be positive or else the function will display an error about imaginary
%roots.  Lastly, inputs must be scalars.
%
%This function was made by Ian J. Silberzweig.  05/20/2017.
function x = qformf(a,b,c)
if exist('a') == 0 || exist('b') == 0 || exist('c') == 0 || isscalar(a) == 0 || isscalar(b) == 0 || isscalar(c) == 0
    errorNeedScaVars.message='Error:  All variables must have scalar inputs.';
    errorNeedScaVars.identifier='qformf:NeedScalarVariables';
    error(errorNeedScaVars)
    return
elseif sqrt( (b^2) - (4 * a * c) ) < 0
    errorNegDesc.message='Error:  Quadratic equation has imaginary roots.';
    errorNegDesc.identifier='qformf:NegDescriminant';
    error(errorNegDesc)
    return
else
    x = zeros(1,2); k = 0;
    for n = 1 : -2 : -1
        k = k + 1;
        x(1,k) = ( (-b) + (n * sqrt( (b^2) - (4 * a * c) ) ) ) / ( 2 * a );
    end
end
end