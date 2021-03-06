class Track < ApplicationRecord
  belongs_to :album
  belongs_to :artist
  has_many :follows, dependent:  :destroy
  has_many :users, through: :follows
  has_many :streams

  include Storext.model(audio_features: {})
end
