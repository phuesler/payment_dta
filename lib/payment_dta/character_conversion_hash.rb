require 'payment_dta/character_conversion'

module DTA
  class CharacterConversionHash < Hash
    include CharacterConversion

    # Character conversion must be done _before_ building the final record to
    # prevent changing the length.
    #
    # @return [String] The original value with character conversion applied.
    def [](key)
      (value = super(key)).respond_to?(:each_char) ? dta_string(value) : value
    end
  end
end
