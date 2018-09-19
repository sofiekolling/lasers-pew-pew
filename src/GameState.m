classdef GameState < handle

  properties(GetAccess=private, SetAccess=private)
    level_nr_
    components_
    starting_ray_
  end 

  methods
    
    % constructor
    function self = GameState()
      self.level_nr_ = 1;  
    end

    function set_starting_ray(self, x, y, angle)
      self.starting_ray_ = Ray(Vec(x, y), angle);
    end

    function active_rays = trace_ray(self)
      % start at the starting point
      active_rays = [self.starting_ray_];
      ray = self.starting_ray_; 
      i = 0;
      while true
        comp = self.find_closest(ray);
        % if a component was hit, add new ray to list of active rays
        i = i + 1;
        if ~isempty(comp)
          disp(comp)
          ray = comp.interact_with(ray);
          active_rays = [active_rays, ray];
        else
          break;
        end
      end
    end

    function draw_state(self)
      active_rays = self.trace_ray(); 
      g = Graphics();
      for c = self.components_
        c = c{1};
        g.draw(c);
      end
      g.draw(active_rays);
    end

    function comp = find_closest(self, ray)
      % finds the first component ray intersects with
      distance = inf;
      % set current component to 'null'
      cur_component = [];
      for c = self.components_
        c = c{1}; % honestly I hate matlab so much
        [point, n] = c.shape.intersection_point(ray);
        % if the current ray intersects this component
        if ~isempty(point.x)
          % compute distance between ray start and intersection
          vec_to_comp = ray.start() - point;
          dist_to_comp = vec_to_comp.norm();
          if dist_to_comp < distance
            % if this distance is smaller than all previous ones,
            % set component to current
            distance = dist_to_comp;
            cur_component = c;
          end
        end
      end
      comp = cur_component;
    end

    function add_component(self, component)
    self.components_{end+1} = component;
  end

  end

end
