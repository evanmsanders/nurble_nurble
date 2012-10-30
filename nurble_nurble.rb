#!/usr/bin/env ruby

require 'rubygems'
require 'engtagger'

engtagger = EngTagger.new

in_filename = 'sample.txt'
in_filename = ARGV[0] unless !ARGV[0]

if File.exist?(in_filename) && File.readable?(in_filename)
    File.open(in_filename, 'r') do |file|
        tagged = engtagger.add_tags(file.read)
        # Everything in uppercase as in the original.
        tagged.upcase!
        # Our NLP engtagger library marks nouns with <nn>, <nnp>, <nnps>, or <nns>.
        # Since no other tags begin with 'n', we can write a regex to match every
        # tag and its contents, where the tag name begins with 'n'. Note that the
        # regex is case insensitive.
        nurbled = engtagger.strip_tags(tagged.gsub(/(?:<[^n].{1,3}>)(?:[^<>]+)(?:<\/[^n].{1,3}>)/i, 'nurble'))
        puts "You didn't specify an input file, so here's a sample instead."
        puts "============================================================="
        puts nurbled
    end
else
    puts 'Either that file does not exist, or you do not have permission to open it.'
end
