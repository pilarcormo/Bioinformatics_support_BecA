require 'pp'
require 'csv'

file_s1 = File.open("s1.csv", "r")
file_s2 = File.open("s2.csv", "r")
file_s3 = File.open("s3.csv", "r")
file_o1 = File.open("o1.csv", "r")
file_o2 = File.open("o2.csv", "r")
file_o3 = File.open("o3.csv", "r")
file_b = File.open("b.csv", "r")



global_hash = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }

def create_hash(file)
	global = []
	namehash = {}
	file.each_line { |line|
		genes = line.split(",")
		name = genes[1].strip
		number = genes[2].strip.to_i
		namehash[name] = number 
		if global.include?(name)
		else 
			global << name 
		end 
	}
	global.flatten!
	return namehash, global
end 

def global(hash, global_hash, name)
	if hash.has_key?(name)
		global_hash[name] << hash[name]
	else 
		global_hash[name] << 0
	end 
	return global_hash
end

s1, global = create_hash(file_s1)
s2, global = create_hash(file_s2)
s3, global = create_hash(file_s3)
o1, global = create_hash(file_o1)
o2, global = create_hash(file_o2)
o3, global = create_hash(file_o3)
b, global = create_hash(file_b)


global.each do |name|
	global_hash[name] = []
	global_hash = global(s1, global_hash, name)
	global_hash = global(s2, global_hash, name)
	global_hash = global(s3, global_hash, name)
	global_hash = global(o1, global_hash, name)
	global_hash = global(o2, global_hash, name)
	global_hash = global(o3, global_hash, name)
	global_hash = global(b, global_hash, name)
end 



global_hash.each do |gene, list|
	CSV.open("unmapped.csv", 'a') do |csv|
    	csv << [gene, global_hash[gene][0], global_hash[gene][1], global_hash[gene][2], global_hash[gene][3], global_hash[gene][4], global_hash[gene][5], global_hash[gene][6], global_hash[gene][7]]
	end
end
	

