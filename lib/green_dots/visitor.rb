# frozen_string_literal: true

require "prism"

class GreenDots::Visitor < Prism::Visitor
	def initialize
		@current_test = nil
		@expectations = []
	end

	attr_accessor :expectations

	def visit_call_node(node)
		case node
		in { name: "test" }
			@current_test = node
		in { receiver: Prism::CallNode[name: "expect", receiver: nil] }
			@expectations << [
				node, @current_test
			]
		else
			nil
		end

		super
	end
end
