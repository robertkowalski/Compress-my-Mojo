#!/usr/bin/ruby

##########
# Check for command line argument
##########
unless ARGV.length == 1 or ARGV.length == 2
  puts "Please specify a project folder name."
  puts "Usage: ruby build.rb [-i] <PROJECTFOLDER-NAME>\n"
  exit
end

##########
# Config #
##########
#projectfolder = 'easterhegg' #your webOS Project folder
if ARGV.length > 1
   projectfolder = ARGV[1] 
else 
   projectfolder = ARGV[0]
end
yui_jar = '~/Desktop/yuicompressor-2.4.2/build/yuicompressor-2.4.2.jar'



####################
require 'fileutils'
require 'find'
include FileUtils


cp_r './'+projectfolder, './.build/'


def compress(path, pattern, yui_jar)
   Find.find(path) do |entry|
      if File.file?(entry) and entry[pattern]
         puts 'compressing: '+entry
         #yui yeah
         string = 'java -jar '+yui_jar+' '+entry+' -o '+entry
         ret  = system(string)
      end
   end
end
 
#compress .js- then .css-files
compress('./.build/', /.+\.js$/, yui_jar)
compress('./.build/', /.+\.css$/, yui_jar)

build = `palm-package ./.build/`
string = build.gsub(/creating package /, "")
filename_array = string.split(/ /)

puts 'Builded '+filename_array[0]+' successfully'

if ARGV[0] == '-i'
   string = 'palm-install '+filename_array[0]
   ret  = system(string)
end


puts 'Deleting temp-files'
string = 'rm -rf ./.build/'
ret  = system(string)


