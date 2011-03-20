#!/usr/bin/ruby

##########
# Check for command line argument
##########
unless ARGV.length == 1
  puts "Please specify a project folder name."
  puts "Usage: ruby build.rb <PROJECTFOLDER-NAME>\n"
  exit
end

##########
# Config #
##########
#projectfolder = 'easterhegg' #your webOS Project folder
projectfolder = ARGV[0]
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

string = 'palm-package ./.build/'
ret  = system(string)

puts 'Deleting temp-files'
string = 'rm -rf ./.build/'
ret  = system(string)


