function [W, X, Y] = A2Bformat(Lf, Rf, Lb, Rb)
    % B-format encoding - W scaled by 1/sqrt(2) (i.e. attenuated by-3db)
    W = (Lf+Rf+(sqrt(2).*(Lb+Rb)))/(2*(sqrt(2)+2));
    X = (Lf+Rf-Lb-Rb)/(sqrt(2)+2);
    Y = (Lf-Rf+Lb-Rb)/(2+sqrt(2));    % Centred Y component
end