require 'open-uri'

kittens = open('http://placekitten.com/')
response_status = kittens.status
response_body = kittens.read[559, 441]

puts response_status
puts response_body

#require "rexml/document"
#
#file = File.open("pets.txt")
#doc = REXML::Document.new file
#file.close
#
#doc.elements.each("pets/pet/name") do |element|
#    puts element
#end

#require 'json'
#
#pets = File.open("pets.txt", "r")
#
#doc = ""
#pets.each do |line|
#    doc << line
#end
#pets.close
#
#puts JSON.parse(doc)

#Consumer Key: kun
#Consumer Secret: 2f7adb0f43801efd
