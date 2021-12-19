# frozen_string_literal: true

require '../suggest-strong-password/password_manager'

password = {
  platform: 'none',
  email: 'none@none.com',
  special_word: 'none'
}
puts 'What is this password for ? facebook ? twitter ? ... 🤷'

unless ARGV[0] == 'fast' || ARGV == 'f'
  loop do
    platform = gets.chomp
    break if /^\w+$/.match?(platform)

    password[:platform] = platform
  end
  puts 'What is your email ? 🤷'
  loop do
    email = gets.chomp
    password[:email] = email
    break if /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.match?(email)

    puts 'Please enter a valid email'
  end

  puts 'Do you have any other thing that you want to use in this password ? (yes/no) 🤷'
  loop do
    answer = gets.chomp.downcase
    case answer
    when 'yes'
      puts 'Enter the thing 🤐'
      special_word = gets.chomp
      password[:special_word] = special_word
    when 'no'
      break
    else
      puts 'please answer with yes or no'
    end
  end
end
pass = PasswordManager.new(password[:platform], password[:email], password[:special_word])
puts "Here's your strong password :) 🦹🏽"
puts pass.generate
