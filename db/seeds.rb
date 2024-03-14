# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# User.delete_all

# users = [
#   {
#     full_name: "Jordan Kim",
#     email: "ricejamie123@gmail.com",
#     gender: "Man",
#     is_hispanic_or_latino: false,
#     race: "American Indian or Alaska Native",
#     is_us_citizen: true,
#     is_first_generation_college_student: true,
#     date_of_birth: Date.new(1997, 7, 20),
#     phone_number: "212-555-1234",
#     bio: "Innovating at the crossroads of art and technology.",
#     classification: "U3"
#   },
#   {
#     full_name: "Casey Lee",
#     email: "ejohnson232@gmail.com",
#     gender: "Transgender",
#     is_hispanic_or_latino: true,
#     race: "Native Hawaiian or Other Pacific Islander",
#     is_us_citizen: false,
#     is_first_generation_college_student: false,
#     date_of_birth: Date.new(1988, 12, 31),
#     phone_number: "323-555-6789",
#     bio: "Bringing diverse perspectives to software development.",
#     classification: "U4"
#   },
#   {
#     full_name: "Morgan Green",
#     email: "tcombs343@gmail.com",
#     gender: "Woman",
#     is_hispanic_or_latino: false,
#     race: "White",
#     is_us_citizen: true,
#     is_first_generation_college_student: true,
#     date_of_birth: Date.new(1993, 4, 18),
#     phone_number: "415-555-7890",
#     bio: "Solving complex problems with simple solutions.",
#     classification: "U1"
#   },
#   {
#     full_name: "Sam Patel",
#     email: "lind343a69@gmail.com",
#     gender: "Man",
#     is_hispanic_or_latino: true,
#     race: "Asian",
#     is_us_citizen: false,
#     is_first_generation_college_student: false,
#     date_of_birth: Date.new(1992, 9, 9),
#     phone_number: "206-555-8901",
#     bio: "Passionate about AI and machine learning.",
#     classification: "U2"
#   },
#   {
#     full_name: "Drew Murphy",
#     email: "don343na48@gmail.com",
#     gender: "Non-binary/non-conforming",
#     is_hispanic_or_latino: false,
#     race: "Black or African American",
#     is_us_citizen: true,
#     is_first_generation_college_student: true,
#     date_of_birth: Date.new(1996, 6, 24),
#     phone_number: "504-555-9012",
#     bio: "Exploring the future of web technologies.",
#     classification: "U3"
#   },
#   {
#     full_name: "Alex Smith",
#     email: "par5343kercolton@gmail.com",
#     gender: "Non-binary/non-conforming",
#     is_hispanic_or_latino: true,
#     race: "Other",
#     is_us_citizen: true,
#     is_first_generation_college_student: false,
#     date_of_birth: Date.new(1999, 5, 15),
#     phone_number: "505-555-0101",
#     bio: "Dedicated to creating accessible technology for all.",
#     classification: "U4"
#   },
#   {
#     full_name: "Taylor Robinson",
#     email: "troyyou355ng@gmail.com",
#     gender: "Woman",
#     is_hispanic_or_latino: false,
#     race: "Asian",
#     is_us_citizen: false,
#     is_first_generation_college_student: true,
#     date_of_birth: Date.new(2000, 8, 22),
#     phone_number: "505-555-0202",
#     bio: "Exploring the intersection of tech and social good.",
#     classification: "U1"
#   },
#   {
#     full_name: "Jamie Lopez",
#     email: "tlawre35353nce@gmail.com",
#     gender: "Man",
#     is_hispanic_or_latino: true,
#     race: "Hispanic or Latino",
#     is_us_citizen: true,
#     is_first_generation_college_student: false,
#     date_of_birth: Date.new(1995, 2, 9),
#     phone_number: "505-555-0303",
#     bio: "Building bridges with code.",
#     classification: "U2"
#   },
#   {
#     full_name: "Riley Johnson",
#     email: "oliverla3535ura@gmail.com",
#     gender: "Transgender",
#     is_hispanic_or_latino: false,
#     race: "Black or African American",
#     is_us_citizen: true,
#     is_first_generation_college_student: true,
#     date_of_birth: Date.new(1998, 11, 30),
#     phone_number: "505-555-0404",
#     bio: "Advancing equality through technology.",
#     classification: "U3"
#   },
#   {
#     full_name: "Jordan Chu",
#     email: "rodriguez3553ruben@gmail.com",
#     gender: "Man",
#     is_hispanic_or_latino: true,
#     race: "Asian",
#     is_us_citizen: false,
#     is_first_generation_college_student: true,
#     date_of_birth: Date.new(1997, 3, 18),
#     phone_number: "505-555-0505",
#     bio: "Innovating for a sustainable future.",
#     classification: "U4"
#   }
# ]
# users.each do |user_attrs|
#     User.create!(user_attrs)
#     rescue ActiveRecord::RecordNotUnique => e
#         puts "A user with the email #{user_data[:email]} already exists. Skipping."
# end

# puts "Database seeded with #{User.count} users."