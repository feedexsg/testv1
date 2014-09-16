require 'csv'

csv_text = File.read('mailinglist.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
	hash = row.to_hash
	hash_name = hash['name']
	if !hash_name.nil?
		hash['password'] = "password"
		hash['password_confirmation'] = "password"
		hash['colony_id'] = 1 
		User.create(hash)
	end
end