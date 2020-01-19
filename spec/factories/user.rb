FactoryBot.define do
  factory :user do
    nickname { FFaker::Lorem.word }
    level { Random.rand(1..99) }
    kind { %w[knight wizard].sample }
  end
end