=begin

Copyright (c) 2011, R. Kowalski All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in 
the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, 
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY 
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
=end

#!/usr/bin/ruby
require 'fileutils'
require 'find'

##########
# Config #
##########

#path to yui-compressor jar
yui_jar = "#{File.dirname(__FILE__)}/yuicompressor-2.4.2.jar"
#path to google closure compiler
closure_jar = "#{File.dirname(__FILE__)}/compiler.jar"

#change your build-folder if wanted
subfolder = ".tmp/"
build_dir = "#{File.dirname(__FILE__)}/"+subfolder

######## HERE THE CONFIG ENDS ############

##########
# Check for command line argument
##########

unless ARGV.length >= 1
  puts ' '
  puts 'Please specify a project folder name.'
  puts 'Usage: ruby build.rb [-i|v1|g|uglys|] <PROJECTFOLDER-NAME>'
  puts 'options are:'
  puts ' '
  puts '-i                  install on device or emulator'
  puts '-v1                 package for webOS 1.4.x devices (old format)'
  puts '-g                  to use google closure compiler (default is YUI-Compressor)'
  puts '-ugly               to use uglifyJS for node'
  puts '-s                  for an app containing services'
  puts 'or combined: -iv1g  to package for webOS 1.4.x devices (old format), packaging with closure compiler and installing them'
  exit
end


##########
# Check for second argument
##########
if ARGV.length == 2
  projectfolder = ARGV[1]
  options = ARGV[0]
elsif ARGV.length > 2
  projectfolder = ARGV[1]
  options = ARGV[0]
  
  i=2
  packages = ''
  while i < ARGV.length do
    if i == 2
      spacer = ''
    else 
      spacer = ' '  
    end
    packages += spacer + build_dir + ARGV[i]
    i += 1
  end
else
  projectfolder = ARGV[0]
end

##########
# processing options
##########
if options
  puts ' '
  if options.index('v1')
    option = '-v1'
    puts '* Using 1.4.5 compability mode'
  end
  if options.index('i')
    install = true
    puts '* Will install after packaging'
  end
  
  if options.index('ugly')
    compiler = {:type => 'ugly'}
    puts '* Will use UglifyJS'
  elsif options.index('g')
    compiler = {:jar => closure_jar, :type => 'google'}
    puts '* Will use google closure compiler'
  else
    compiler = {:jar => yui_jar, :type => 'yui'}
  end 
  puts ' '
else
  compiler = {:jar => yui_jar, :type => 'yui'}
end

##########
# add options to palm-package commandline
##########

if option and option == '-v1'
  option = "--use-v1-format"
else
  option = ""
end


puts 'Deleting temp-files...'
string = 'rm -rf '+build_dir
ret  = system(string)
puts ' '

# copy
if File.directory? projectfolder
  `cp -RL #{projectfolder} #{build_dir}`
else
  puts '*** ERROR: Please specify a valid directory'
  exit
end

def compress(path, pattern, compiler)
  Find.find(path) do |entry|
    if File.file?(entry) and entry[pattern]
      puts 'compressing: '+entry
      #yui yeah
      if(compiler[:type] == 'yui')
        string = 'java -jar '+compiler[:jar]+' '+entry+' -o '+entry
      elsif(compiler[:type] == 'google')
        string = 'java -jar '+compiler[:jar]+' --js='+entry
      else  
        string = 'uglifyjs '+ '--overwrite ' + entry
      end
      ret  = system(string)
    end
  end
end

# compress .js- then .css-files
compress(build_dir, /.+\.js$/, compiler)

if(compiler[:type] == 'yui')
  compress(build_dir, /.+\.css$/, compiler)
end

if packages.nil?
  build_output = `palm-package #{option} #{build_dir}`
else 
  build_output = `palm-package #{packages}`
end


string = build_output.gsub(/creating package /, "")
filename_array = string.split(/ /)

puts 'Builded '+filename_array[0]+' successfully'

# installing if wanted
if install
  string = 'palm-install '+filename_array[0]
  ret  = system(string)
end

puts 'Deleting temp-files...'
string = 'rm -rf '+build_dir
ret  = system(string)
