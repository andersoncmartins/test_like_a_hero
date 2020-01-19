FactoryBot.define do
  factory :enemy do
    name { FFaker::Lorem.word  }
    power_base { Random.rand(1..9999) }
    power_step { Random.rand(1..9999) }
    level { Random.rand(1..99) }
    kind { %w[goblin orc demon dragon].sample }
  end
end
