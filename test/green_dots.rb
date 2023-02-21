# frozen_string_literal: true

class Foo
	def self.bar
		"original"
	end
end

GreenDots.describe GreenDots do
	test { assert true }
	test(skip: true) { assert false }

	test { expect(1) == 1 }
	test(skip: true) { expect(1) == 2 }

	test { expect(1) != 2 }
	test(skip: true) { expect(1) != 1 }

	test { expect { raise ArgumentError }.to_raise(ArgumentError) }
	test { expect { raise ArgumentError }.to_raise(StandardError) }

	test(skip: true) { expect { "No raise" }.to_raise(NameError) }
	test(skip: true) { expect { raise NameError }.to_raise(ArgumentError) }
	test(skip: true) { expect { raise StandardError }.to_raise(ArgumentError) }

	test do
		expect(Foo).to_receive(:bar)
		Foo.bar(1, 2, 3)
	end

	test(skip: true) do
		expect(Foo).to_receive(:bar)
	end

	test do
		expect(Foo).to_receive(:bar) { "Baz" }
		expect(Foo.bar) == "Baz"
	end

	test do
		expect(Foo).to_receive(:bar) do |a, b, c:|
			expect(a) == 1
			expect(b) == 2
			expect(c) == 3
		end

		Foo.bar(1, 2, c: 3)
	end
end
