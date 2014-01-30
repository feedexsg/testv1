TimeSelect = ["AM", "PM"].collect {|str| (1..12).collect {|num| num.to_s + " #{str}"}}.flatten
