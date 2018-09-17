classdef Interactable < handle

  properties(Constant)
    r_index = 1.333;  % refractive index
  end

  methods(Abstract)
    % all interactions are either:
    % absorbtion, reflection, transmission.
    %
    % @param angle_in Incident angle of incoming ray
    % @return angle_out Either reflective or transmittive angle of outgoing ray
    interact(self, angle_in)
  end

end