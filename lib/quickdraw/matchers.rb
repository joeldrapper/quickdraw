# frozen_string_literal: true

module Quickdraw::Matchers
	autoload :Boolean, "quickdraw/matchers/boolean"
	autoload :CaseEquality, "quickdraw/matchers/case_equality"
	autoload :Change, "quickdraw/matchers/change"
	autoload :Equality, "quickdraw/matchers/equality"
	autoload :Include, "quickdraw/matchers/include"
	autoload :Predicate, "quickdraw/matchers/predicate"
	autoload :RespondTo, "quickdraw/matchers/respond_to"
	autoload :ToBeA, "quickdraw/matchers/to_be_a"
	autoload :ToHaveAttributes, "quickdraw/matchers/to_have_attributes"
	autoload :ToRaise, "quickdraw/matchers/to_raise"
	autoload :ToReceive, "quickdraw/matchers/to_receive"
end
