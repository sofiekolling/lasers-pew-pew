classdef Graphics < handle

  properties(SetAccess = private, GetAccess = private)
    fig_;
    xlims_ = [0, 1];
    ylims_ = [0, 1];
  end

  methods

    function self = Graphics()
      self.fig_ = figure;
      self.set_range([0, 1, 0, 1]);
    end

    function set_range(self, ranges)
      axis(ranges);
      self.xlims_ = ranges(1:2);
      self.ylims_ = ranges(3:4);
      dx = self.xlims_(2) - self.xlims_(1);
      dy = self.ylims_(2) - self.ylims_(1);
      dz = 1;
      pbaspect([dx, dy, dz]/max([dx, dy, dz]));
    end

    function draw_main_menu(self, start_button_callback, quit_callback)
      start_button = uicontrol('Parent', self.fig_,...
            'String', 'Start game', 'Units', 'normalized',...
            'Position', [0.5 0.5 0.2 0.1]);
      start_button.Callback = start_button_callback;
      quit_button = uicontrol('Parent', self.fig_,...
            'String', 'Quit', 'Units', 'normalized',...
            'Position', [0.5 0.4 0.2 0.1]);
      quit_button.Callback = quit_callback;
    end

    function draw(self, obj)
      if isa(obj, 'Mirror')
        self.draw_mirror(obj);
      elseif isa(obj, 'Lens')
        self.draw_lens(obj);
      elseif isa(obj, 'Target')
        self.draw_target(obj);
      elseif isa(obj, 'BlackBody')
        self.draw_blackbody(obj);
      elseif isa(obj, 'Ray')
        self.draw_ray_set(obj);
      else
        error('Invalid data type for drawing');
      end
    end

    function draw_target(self, target)
      if isa(target.shape, 'Circle')
        [x, y] = self.circle_xy(target.shape);
      elseif isa(target.shape, 'Rectangle')
        [x, y] = self.rectangle_xy(target.shape);
      else
        error('Shape drawing not implemented for Target');
      end
      self.draw_shape(x, y, 'red', 'red'); 
    end

    function draw_blackbody(self, blackbody)
      if isa(blackbody.shape, 'Circle')
        [x, y] = self.circle_xy(blackbody.shape);
      elseif isa(blackbody.shape, 'Rectangle')
        [x, y] = self.rectangle_xy(blackbody.shape);
      else
        error('Shape drawing not implemented for BlackBody');
      end
      self.draw_shape(x, y, 'black', [0, 0, 0]);
    end

    function draw_mirror(self, mirror)
      if isa(mirror.shape, 'Circle')
        [x, y] = self.circle_xy(mirror.shape);
      elseif isa(mirror.shape, 'Rectangle')
        [x, y] = self.rectangle_xy(mirror.shape);
      else
        error('Shape drawing not implemented');
      end
        self.draw_shape(x, y, 'cyan', [0.5, 0.5, 0.5]);
    end

    function draw_lens(self, lens)
      if isa(lens.shape, 'Circle')
        [x, y] = self.circle_xy(lens.shape);
        self.draw_shape(x, y, 'cyan', 'cyan');
      elseif isa(lens.shape, 'Rectangle')
        [x, y] = self.rectangle_xy(lens.shape);
        self.draw_shape(x, y, 'cyan', 'cyan');
      else
        error('Shape drawing not implemented');
      end
    end

    function draw_shape(self, x, y, edge_color, fill_color)
      f = fill(x, y, fill_color);
      p = line('Xdata', x, 'Ydata', y, 'Color', edge_color, 'LineWidth', 2);
    end

    function draw_ray_set(self, rays)
      xs = zeros(1, length(rays));
      ys = zeros(1, length(rays));
      for i=1:length(rays)
        vertex = rays(i).start();
        xs(i) = vertex.x;
        ys(i) = vertex.y;
      end
      plot(xs, ys, 'r', 'LineWidth', 2);
      self.draw_ray(rays(end));
      self.set_range([self.xlims_, self.ylims_]);
    end

    function [x, y] = circle_xy(self, circle)
      r = circle.radius;
      p = circle.location();
      theta = linspace(0, 2*pi, 100);
      x = r*cos(theta) + p.x;
      y = r*sin(theta) + p.y;
    end

    function [x, y] = rectangle_xy(self, rectangle)
      [w, h] = rectangle.width_height(); 
      s = rectangle.slant();
      p = rectangle.location();
      x = [-w/2, w/2, w/2, -w/2, -w/2];
      y = [-h/2, -h/2, h/2, h/2, -h/2];
      xrot = x*cos(s) - y*sin(s);
      yrot = x*sin(s) + y*cos(s);
      x = xrot + p.x;
      y = yrot + p.y;
    end

    function draw_ray(self, ray)
      angle = ray.angle();
      if isempty(angle)
        return;
      end
      start = ray.start();
      [m, b] = ray.line();
      if (-pi/2 <= angle) & (angle < pi/2)
        xmin = start.x;
        xmax = self.xlims_(2);
      else
        xmin = self.xlims_(1);
        xmax = start.x;
      end
      xs = [xmin, xmax];
      ys = m*xs + b;
      plot(xs, ys, 'r', 'LineWidth', 2);
      self.set_range([self.xlims_, self.ylims_]);
    end

    function fig = get_figure(self)
      fig = self.fig_;
    end

    function ax = get_axes(self)
      ax = self.fig_.CurrentAxes;
    end

  end

end
