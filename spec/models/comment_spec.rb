require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:article)}
  it { should validate_presence_of(:commenter)}
end
