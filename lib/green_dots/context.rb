module GreenDots::Context
	def describe(description = nil, &block)
		Class.new(self, &block).run
	end

	alias_method :context, :describe

	def test(name = nil, skip: false, &block)
		(@tests ||= []) << {
			name: name,
			block: block,
			skip: skip
		}
	end
end