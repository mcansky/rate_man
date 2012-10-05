module RateMan
  class CurrencyDuo
    attr_accessor :from, :to, :raw, :rate
    def initialize(from_cur, to_cur)
      @from = from_cur
      @to = to_cur
    end

    def query
      self.raw = RateMan.query(from, to)
      self.rate = raw[3].to_f
      self
    end

    def hash
      raise ArgumentError, "you must query google for the rate first" unless rate && raw
      {from_to: from + ':' + to,
       from_cur: [1, from],
       to_cur: [rate, to],
       rate: rate,
       inv_rate: 1 / rate}
    end

    def json
      hash.to_json
    end
  end
end
