# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'simulation'

Game.destroy_all

[
  'beacon',
  'bee-hive',
  'blinker',
  'block',
  'boat',
  'loaf',
  'toad',
  'tub',
  'penta-decathlon',
  'pulsar',
].each do |name|
  File.open("db/examples/#{name}") do |f|
    g = Game.create!(name: name)
    initial_step = Simulation.read_generation(f)
    height, width = Simulation.read_dimensions(f)
    g.width = width
    g.height = height
    g.save

    s = Simulation.read_board(f, width, height)
    g.generations.create(initial: true, step: initial_step, board: s)
  end
end

