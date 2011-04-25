class Member < ActiveRecord::Base
belongs_to :user
has_many :card
has_many :valid_card, :class_name=>"Card", :finder_sql =>
    'SELECT card.* ' +
    'FROM cards card ' +
    'WHERE card.member_id = #{id} AND card.card_id NOT IN (SELECT ch.card_id FROM card_histories ch WHERE ch.member_id= #{id})'
belongs_to :branch
has_many :read_shelf
has_many :read_next_shelf
has_many :lost_card, :class_name => "CardHistory"
end
