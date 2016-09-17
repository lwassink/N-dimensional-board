#!/usr/bin/ruby
#
# Copyright (C) 2016 Luke Wassink <lwassink@gmail.com>
#
# Distributed under terms of the MIT license.
#


class Board
  attr_reader :data

  # the board can be n-dimensional
  # to initialize, we supply a dimension vector with n-entries
  # it defaults to a chess board
  def initialize(dimensions = [8,8])
    @dimensions = dimensions
    @data = Array.new(size)
    @dim = @dimensions.length
  end

  def size
    @dimensions.reduce(&:*)
  end

  def [](pos)
    @data[index(pos)]
  end

  def []=(pos, value)
    @data[index(pos)] = value
  end


  # return the index in @data pecified by a postion vector
  # used by the [] and []= methods
  def index(pos)
    idx = 0

    @dim.times do |i|
      if i < @dim - 1
        idx += pos[i] * @dimensions.drop(i + 1).reduce(&:*)
      else
        idx += pos[i]
      end
    end

    idx
  end

  # work backwards and find a position from an index
  def position(idx)
    pos = []

    @dim.times do |i|
      if i < @dim - 1
        row_length = @dimensions.drop(i+1).reduce(&:*)
        pos << idx / row_length
        idx -= pos.last * row_length
      else
        pos << idx
      end
    end

    pos
  end

  def positions
    (0...size).map { |idx| position(idx) }
  end

  def each_with_pos(&prc)
    positions.each do |pos|
      prc.call(self[pos], pos)
    end
  end
end

