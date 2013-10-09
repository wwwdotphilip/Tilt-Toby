local M = {}

function M.trueDestroy(toast)
    toast:removeSelf();
    toast = nil;
end

function M.new(pText, pTime)
    local pTime = pTime;
    local toast = display.newGroup();
    
    toast.text = display.newText(toast, pText, 14, 12, native.systemFont, 20);
    toast.background = display.newRoundedRect( toast, 0, 0, toast.text.width + 24, toast.text.height + 24, 16 );
    toast.background.strokeWidth = 4
    toast.background:setFillColor(72, 64, 72)
    toast.background:setStrokeColor(96, 88, 96)
    
    toast.text:toFront();
    
    toast:setReferencePoint(toast.width*.5, toast.height*.5)
    --utils.maintainRatio(toast);
    
    toast.alpha = 0;
    toast.transition = transition.to(toast, {time=250, alpha = 1});
    
    if pTime ~= nil then
        timer.performWithDelay(pTime, function() M.destroy(toast) end);
    end
    
    toast.x = display.contentWidth * .5
    toast.y = display.contentHeight * .9
    
    return toast;
end

function M.destroy(toast)
    toast.transition = transition.to(toast, {time=250, alpha = 0, onComplete = function() M.trueDestroy(toast) end});
end

return M;

