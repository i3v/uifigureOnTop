function  demo_uifigureOnTop(  )
%DEMO_UIFIGUREONTOP is a simple test of uifigureOnTop function functionality
%

uifig=uifigure('Name','demo uifigure (should be always on top)');

uifigureOnTop(uifig);

end

