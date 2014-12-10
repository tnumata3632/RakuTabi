# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require "csv"

Image.create([image_id: 'animal00', keywords: '鳥', path: 'animal00.png'])
Image.create([image_id: 'animal01', keywords: 'サファリ', path: 'animal01.png'])
Image.create([image_id: 'animal02', keywords: '魚', path: 'animal02.png'])
Image.create([image_id: 'feel00', keywords: '学ぶ', path: 'feel00.png'])
Image.create([image_id: 'feel01', keywords: 'スリル', path: 'feel01.png'])
Image.create([image_id: 'feel02', keywords: 'タイムスリップ', path: 'feel02.png'])
Image.create([image_id: 'feel03', keywords: '魅惑', path: 'feel03.png'])
Image.create([image_id: 'feel04', keywords: '太陽', path: 'feel04.png'])
Image.create([image_id: 'feel05', keywords: '日曜日', path: 'feel05.png'])
Image.create([image_id: 'food00', keywords: 'ワイン', path: 'food00.png'])
Image.create([image_id: 'food01', keywords: 'ビール', path: 'food01.png'])
Image.create([image_id: 'food02', keywords: 'グルメ', path: 'food02.png'])
Image.create([image_id: 'nature00', keywords: '山脈', path: 'nature00.png'])
Image.create([image_id: 'nature01', keywords: '海', path: 'nature01.png'])
Image.create([image_id: 'nature02', keywords: 'オーロラ', path: 'nature02.png'])
Image.create([image_id: 'nature03', keywords: '雪', path: 'nature03.png'])
Image.create([image_id: 'nature04', keywords: '星空', path: 'nature04.png'])
Image.create([image_id: 'person00', keywords: 'ひとり', path: 'person00.png'])
Image.create([image_id: 'person01', keywords: 'カップル', path: 'person01.png'])
Image.create([image_id: 'person02', keywords: '女子', path: 'person02.png'])
Image.create([image_id: 'person03', keywords: 'シニア', path: 'person03.png'])
Image.create([image_id: 'scene00', keywords: '田舎', path: 'scene00.png'])
Image.create([image_id: 'scene01', keywords: '都会', path: 'scene01.png'])
Image.create([image_id: 'scene02', keywords: '遺跡', path: 'scene02.png'])
Image.create([image_id: 'scene03', keywords: 'シルクロード', path: 'scene03.png'])
Image.create([image_id: 'sports00', keywords: 'サッカー', path: 'sports00.png'])
Image.create([image_id: 'sports01', keywords: 'ゴルフ', path: 'sports01.png'])
Image.create([image_id: 'sports02', keywords: 'スノボー', path: 'sports02.png'])
Image.create([image_id: 'sports03', keywords: 'ダイビング', path: 'sports03.png'])
Image.create([image_id: 'sports04', keywords: '登山', path: 'sports04.png'])
Image.create([image_id: 'sports05', keywords: 'テニス', path: 'sports05.png'])
Image.create([image_id: 'spot00', keywords: '美術', path: 'spot00.png'])
Image.create([image_id: 'spot01', keywords: 'カジノ', path: 'spot01.png'])
Image.create([image_id: 'spot02', keywords: '温泉', path: 'spot02.png'])
Image.create([image_id: 'spot03', keywords: '城', path: 'spot03.png'])
Image.create([image_id: 'spot04', keywords: '花', path: 'spot04.png'])
Image.create([image_id: 'spot05', keywords: '建築', path: 'spot05.png'])
Image.create([image_id: 'spot06', keywords: '写真', path: 'spot06.png'])
Image.create([image_id: 'spot07', keywords: 'クラッシック', path: 'spot07.png'])
Image.create([image_id: 'spot08', keywords: '音楽', path: 'spot08.png'])
Image.create([image_id: 'trans00', keywords: '鉄道', path: 'trans00.png'])
Image.create([image_id: 'trans01', keywords: '船', path: 'trans01.png'])
Image.create([image_id: 'trans02', keywords: '気球', path: 'trans02.png'])
#p Dir.glob('db/city/*')
Dir.glob('db/city/*') {|f|
  puts f
  reader = CSV.open(f, 'r')
  reader.shift
  s = reader.shift[0]
  p s
  country = s[7...s.index('(')]
  reader.each do |row|
    City.create(:country => country, :city_jp => row[0], :city_en => row[1], :lat => row[2],
                :lng => row[3], :city_type => row[4], :layer => row[5], :code_no => row[6])
  end
}

Ask.create([question: '腕を組んだ時、どちらの腕が上にきてる？', image_l: 'q00_l.png', image_r: 'q00_r.png'])
Ask.create([question: 'ドラえもんの道具を一つだけもらえるなら？', image_l: 'q02_l.png', image_r: 'q02_r.png'])
Ask.create([question: '時間旅行するなら？', image_l: 'q05_l.png', image_r: 'q05_r.png'])
Ask.create([question: '動物に生まれ変わるとしたらどっち？', image_l: 'q07_l.png', image_r: 'q07_r.png'])
Ask.create([question: '気になるカードはどっち？', image_l: 'q11_l.png', image_r: 'q11_r.png'])
Ask.create([question: '気になる札はどっち？', image_l: 'q12_l.png', image_r: 'q12_r.png'])