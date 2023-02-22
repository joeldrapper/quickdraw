module GreenDots::Context
	def describe(description = nil, &block)
		Class.new(self, &block).run
	end

	alias_method :context, :describe

	def test(name = nil, skip: false, &block)
		{
			name: name,
			block: block,
			skip: skip
		}.tap { (@tests ||= []) << _1 }
	end
end