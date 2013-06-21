# YAML (Psych) has a bug preventing serialization of objects inheriting from Delegator
# Nori uses delegators for all value nodes.
# This monkey-patch has been taken from here:
# https://github.com/tenderlove/psych/issues/100

class Delegator
  def encode_with coder
    ivars = instance_variables.reject {|var| /\A@delegate_/ =~ var}
    coder['obj'] = __getobj__
    unless ivars.empty?
      coder['ivars'] = Hash[ivars.map{|var| [var[1..-1], instance_variable_get(var)]}]
    end
  end

  def init_with coder
    (coder['ivars'] || {}).each do |k, v|
      instance_variable_set :"@#{k}", v
    end
    __setobj__ coder['obj']
  end
end
