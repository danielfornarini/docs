# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Document, type: :model do
  validate_associations!
  check_validations!
end
