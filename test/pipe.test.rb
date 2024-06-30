# frozen_string_literal: true

test "with_reader and with_writer" do
	pipe = Quickdraw::Pipe.new

	Process.fork do
		pipe.with_writer do |writer|
			writer.write "Hello, world!"
		end
	end

	pipe.with_reader do |reader|
		expect(reader.read) == "Hello, world!"
	end
end
