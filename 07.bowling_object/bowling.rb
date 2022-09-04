# frozen_string_literal: true

require_relative 'game'
require_relative 'frame'
require_relative 'shot'

def main
  game = Game.new(ARGV[0])
  puts game.point_result
end

main if __FILE__ == $PROGRAM_NAME
