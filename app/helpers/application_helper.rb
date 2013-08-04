module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title = nil)
    base_title = ENV["SITE_NAME"]
    if page_title.nil?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end  

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def active_css current
    if current_page?(current)
      html = 'class="active"'.html_safe
    end
  end 

  def link_to_add_fields(name, f, path, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(path + association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def pagination_links(collection, options = {})
    options[:renderer] ||= BootstrapPaginationHelper::LinkRenderer
    options[:class] ||= 'pagination'
    options[:inner_window] ||= 2
    options[:outer_window] ||= 1
    #options[:previous_label] ||= h("<< Previous")
    #options[:next_label] ||= h("Next >>")
    will_paginate(collection, options)
  end  


  def link_to_blank(body, url_options = {}, html_options = {})
    link_to(body, url_options, html_options.merge(target: "_blank"))
  end  

  def is_active_tab(arg1, arg2)
    if arg1 == arg2
      "active"
    else
      ""
    end
  end 

  # Returns the name as a delimited string from an object list
  def display_delimited_string(object_list, method_name = 'name', delimiter = ',')
    delimited_string = ''
    object_list.each do |oa|
      if object_list.last.send(method_name) == oa.send(method_name)
        delimited_string += "#{oa.send(method_name).titleize}"
      else
        delimited_string += "#{oa.send(method_name).titleize}#{delimiter} "
      end
    end       
    return delimited_string
  end   

end
