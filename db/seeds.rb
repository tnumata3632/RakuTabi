# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@image = Image.new
@image.image_id = "town00"
@image.keywords = "ロンドン"
@image.path = @image.image_id + ".jpg"
@image.save

@image = Image.new
@image.image_id = "town01"
@image.keywords = "ストリート"
@image.path = @image.image_id + ".jpg"
@image.save

@image = Image.new
@image.image_id = "town02"
@image.keywords = "ニューヨーク"
@image.path = @image.image_id + ".jpg"
@image.save

@image = Image.new
@image.image_id = "town03"
@image.keywords = "渋滞"
@image.path = @image.image_id + ".jpg"
@image.save

@image = Image.new
@image.image_id = "nature00"
@image.keywords = "森林"
@image.path = @image.image_id + ".jpg"
@image.save

@image = Image.new
@image.image_id = "nature01"
@image.keywords = "ビーチリゾート"
@image.path = @image.image_id + ".jpg"
@image.save

@image = Image.new
@image.image_id = "nature02"
@image.keywords = "海 山"
@image.path = @image.image_id + ".jpg"
@image.save

@image = Image.new
@image.image_id = "nature03"
@image.keywords = "国立公園"
@image.path = @image.image_id + ".jpg"
@image.save
