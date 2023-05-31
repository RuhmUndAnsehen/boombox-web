# frozen_string_literal: true

json.array! @equities, partial: 'equities/equity', as: :equity
