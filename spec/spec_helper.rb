require File.join(File.dirname(__FILE__),"../",'lib/oxford')

def randomstring(length)
  o = [('a'..'z'), ('A'..'Z')].map{|i| i.to_a}.flatten
  return (0..length).map { o[rand(o.length)] }.join
end


