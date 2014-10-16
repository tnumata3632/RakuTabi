# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@image = Image.new
@image.image_id = "town"
@image.keywords = "ニューヨーク"
@image.path = "town.png"
@image.save

@image = Image.new
@image.image_id = "sea"
@image.keywords = "ビーチ リゾート"
@image.path = "sea.png"
@image.save
