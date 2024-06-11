# frozen_string_literal: true

test "measures the duration of the given block" do
	duration = Quickdraw::Timer.time do
		sleep(0.01)
	end

	expect(duration).to_be_a(Quickdraw::Timer::Duration)

	expect(duration.nanoseconds) >= 10_000_000
	expect(duration.nanoseconds) <= 15_000_000
end
