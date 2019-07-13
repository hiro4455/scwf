# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

CSV.foreach('db/users.csv', headers: true) do |csv|
  raw = {
    id: csv['社員番号'],
    name: csv['名前1'], 
    mail: csv['mailアドレス'],
    kubun: csv['区分'],
    jigyoubu: csv['所属事業部'],
    bumon: csv['所属部門'],
    ka: csv['所属課'],
    job_class: csv['職位']
  }
  user = User.find_or_initialize_by(id: raw[:id])
  user.update_attributes!(raw)
end

