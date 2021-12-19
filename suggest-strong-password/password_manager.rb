# frozen_string_literal: true

require 'active_support'
class PasswordManager
  def initialize(platform, email, special_word = '')
    @platform = platform
    @email = email
    @special_word = special_word
    @pass_gen = pass = "App:#{platform}$$#{rand(1000)}$$#{special_word.capitalize.split(//)}"
    @key = ActiveSupport::KeyGenerator.new(@pass_gen).generate_key(SecureRandom.random_bytes(2), 32)
    @enc = ActiveSupport::MessageEncryptor.new(key)
  end

  def generate(pass_length = 8)
    pass_length = 8 if pass_length.zero?
    encrypted_pass = enc.encrypt_and_sign(pass_gen)
    sliced_pass =encrypted_pass.slice(0..pass_length)
    save_pass_details(sliced_pass,encrypted_pass)
    sliced_pass
  end

  def save_pass_details(sliced_pass,password)
    File.open('generated_passwords.csv', 'a') do |file|
      file.puts "#{email},#{platform},#{sliced_pass},#{password}\n"
    end
  end

  private

  attr_reader :special_word, :key, :platform, :enc, :email, :pass_gen
end
