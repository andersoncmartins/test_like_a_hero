class Weapon < ApplicationRecord
  validates :level, numericality: { greather_than: 0, less_than_or_equal_to: 99 }
  validates :power_step, numericality: { equal_to: 100 }
  # validates :power_base, numericality: { greather_than: 2999 }

  def current_power
    (power_base + ((level - 1) * power_step))
  end

  def title
    "#{name} ##{level}"
  end
end
