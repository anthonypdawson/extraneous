require 'md5'

str=""
for i in 1..100
	by_two = false
	by_five = false
	val = ""
	if(i%2 == 0)
		by_two = true
	end
	if(i % 5 == 0)
		by_five = true
	end
	if(by_two)
			val = "#{i}A"
	end
	if(by_five)
		val = "#{i}B"
	end
	if(by_five && by_two)	
		val = "#{i}C"
	end
	if(!by_five && !by_two)
		val = i
	end
	str += val.to_s.downcase
end
puts str
str = MD5::MD5.md5(str)
#str = str.split('').map(&:ord).join
puts str.to_s.downcase
