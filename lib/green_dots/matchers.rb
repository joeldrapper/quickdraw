module GreenDots::Matchers
	autoload :Boolean, "green_dots/matchers/boolean"
	autoload :CaseEquality, "green_dots/matchers/case_equality"
	autoload :Change, "green_dots/matchers/change"
	autoload :Equality, "green_dots/matchers/equality"
	autoload :Include, "green_dots/matchers/include"
	autoload :Predicate, "green_dots/matchers/predicate"
	autoload :RespondTo, "green_dots/matchers/respond_to"
	autoload :ToBeA, "green_dots/matchers/to_be_a"
	autoload :ToHaveAttributes, "green_dots/matchers/to_have_attributes"
	autoload :ToRaise, "green_dots/matchers/to_raise"
	autoload :ToReceive, "green_dots/matchers/to_receive"
end
