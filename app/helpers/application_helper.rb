module ApplicationHelper
  def svg(name, **)
    inline_svg_tag("svgs/#{name}.svg", **)
  end

end
