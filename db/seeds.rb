# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


DEFAULT_INSECURE_PASSWORD = 'password1'

User.create ({
	first_name: "Prabhakar",
	last_name: "Undurthi",
	profile_name: "prabhakar",
	email: "undurthi.prabhakar@gmail.com",
	password: DEFAULT_INSECURE_PASSWORD,
	password_confirmation: DEFAULT_INSECURE_PASSWORD

	})

User.create ({
	first_name: "Michel",
	last_name: "Joe",
	profile_name: "michel",
	email: "micheljoe85@gmail.com",
	password: DEFAULT_INSECURE_PASSWORD,
	password_confirmation: DEFAULT_INSECURE_PASSWORD

	})


User.create ({
	first_name: "Steve",
	last_name: "Huffman",
	profile_name: "steve",
	email: "stevehuffman987@gmail.com",
	password: DEFAULT_INSECURE_PASSWORD,
	password_confirmation: DEFAULT_INSECURE_PASSWORD

	})


 User.create ({
	first_name: "Zuke",
	last_name: "Burg",
	profile_name: "zuke",
	email: "zukeburg@gmail.com",
	password: DEFAULT_INSECURE_PASSWORD,
	password_confirmation: DEFAULT_INSECURE_PASSWORD

	})

 prabhakar = User.find_by_email('undurthi.prabhakar@gmail.com')
 michel =  User.find_by_email('micheljoe85@gmail.com')
 zuke = User.find_by_email('zukeburg@gmail.com')
 steve = User.find_by_email('stevehuffman987@gmail.com')


 seed_user = prabhakar

 seed_user.statuses.create(content: "Hello, world")
 michel.statuses.create(content: "Hi, I'm Michel")
 zuke.statuses.create(content: "I want to learn the stuff!!! I love at treehouse.")
 steve.statuses.create(content: "Hi, I'm steve")

 UserFriendship.request(seed_user, michel).accept!
 UserFriendship.request(seed_user,zuke).block!
 UserFriendship.request(seed_user, steve)
