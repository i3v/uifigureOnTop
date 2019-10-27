# uifigureOnTop
Allows to trigger figure's "Always On Top" state for Matlab `uifigure()` windows.

## Main features: 
* Turns "always on top" state on and off
* Returns previous "always on top" state 


## Quickstart: 
Try the demo: 
```Matlab
>> demo_uifigureOnTop();
```
or apply the same to your own figure: 
```Matlab
>> hf=uifigure; ha=uiaxes(hf); imshow('peppers.png','Parent',ha); uifigureOnTop(hf);
```
