function overlapvalue = overlap(patch_A, patch_B)
    a_left   = patch_A(1);
    a_top    = patch_A(2);
    a_right  = patch_A(1) + patch_A(3) - 1; 
    a_bottom = patch_A(2) + patch_A(4) - 1;
    
    
    b_left   = patch_B(1);
    b_top    = patch_B(2);
    b_right  = patch_B(1) + patch_B(3) - 1; 
    b_bottom = patch_B(2) + patch_B(4) - 1;
    
    left     = max(a_left, b_left);
    right    = min(a_right, b_right);
    top      = max(a_top, b_top);
    bottom   = min(a_bottom, b_bottom);
    
    if left > right || top > bottom
        overlapvalue = 0;
    else
        a_area = patch_A(3)*patch_A(4);
        b_area = patch_B(3)*patch_B(4);
        area = (right - left + 1) * (bottom - top + 1);
        overlapvalue = area / (a_area + b_area - area);
    end
end