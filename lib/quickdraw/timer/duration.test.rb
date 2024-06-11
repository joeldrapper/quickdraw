# frozen_string_literal: true

def duration_string(n)
	Quickdraw::Timer::Duration.new(n).to_s
end

test "nanoseconds" do
	expect(duration_string(1)) == "1ns"
	expect(duration_string(12)) == "12ns"
	expect(duration_string(123)) == "123ns"
end

test "microseconds" do
	expect(duration_string(1_234)) == "1.2μs"
	expect(duration_string(12_345)) == "12.3μs"
	expect(duration_string(123_456)) == "123.5μs"
end

test "milliseconds" do
	expect(duration_string(1_234_567)) == "1.2ms"
	expect(duration_string(12_345_678)) == "12.3ms"
	expect(duration_string(123_456_789)) == "123.5ms"
end

test "seconds" do
	expect(duration_string(1_234_567_890)) == "1.2s"
	expect(duration_string(12_345_678_901)) == "12.3s"
end

test "minutes" do
	expect(duration_string(60_000_000_000)) == "1m 0s"
	expect(duration_string(61_234_567_890)) == "1m 1s"
	expect(duration_string(123_456_789_012)) == "2m 3s"
end
