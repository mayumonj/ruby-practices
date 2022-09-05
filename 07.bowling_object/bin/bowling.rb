# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/frame'
require_relative '../lib/shot'

def main
  game = Game.new(ARGV[0])
  puts game.point_result
end

main if __FILE__ == $PROGRAM_NAME
